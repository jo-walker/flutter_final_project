import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Customer Model
class Customer {
  final int? id;
  final String firstName;
  final String lastName;
  final String address;
  final String birthday;

  Customer({this.id, required this.firstName, required this.lastName, required this.address, required this.birthday});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'birthday': birthday,
    };
  }
}

// Customer Provider
class CustomerProvider with ChangeNotifier {
  late Database _database;
  List<Customer> _customers = [];
  final storage = FlutterSecureStorage();

  List<Customer> get customers => _customers;

  CustomerProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'customer_database.db');

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE customers(id INTEGER PRIMARY KEY AUTOINCREMENT, firstName TEXT, lastName TEXT, address TEXT, birthday TEXT)",
        );
      },
      version: 1,
    );
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final List<Map<String, dynamic>> maps = await _database.query('customers');
    _customers = List.generate(maps.length, (i) {
      return Customer(
        id: maps[i]['id'],
        firstName: maps[i]['firstName'],
        lastName: maps[i]['lastName'],
        address: maps[i]['address'],
        birthday: maps[i]['birthday'],
      );
    });
    print('Customers fetched: $_customers');  // Debugging line
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    await _database.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Customer added: ${customer.toMap()}');  // Debugging line
    _fetchCustomers();
  }

  Future<void> updateCustomer(Customer customer) async {
    await _database.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
    _fetchCustomers();
  }

  Future<void> deleteCustomer(int id) async {
    await _database.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    _fetchCustomers();
  }

  Future<void> saveLastCustomerData(Customer customer) async {
    await storage.write(key: 'firstName', value: customer.firstName);
    await storage.write(key: 'lastName', value: customer.lastName);
    await storage.write(key: 'address', value: customer.address);
    await storage.write(key: 'birthday', value: customer.birthday);
  }

  Future<Customer?> getLastCustomerData() async {
    String? firstName = await storage.read(key: 'firstName');
    String? lastName = await storage.read(key: 'lastName');
    String? address = await storage.read(key: 'address');
    String? birthday = await storage.read(key: 'birthday');

    if (firstName != null && lastName != null && address != null && birthday != null) {
      return Customer(
        firstName: firstName,
        lastName: lastName,
        address: address,
        birthday: birthday,
      );
    }
    return null;
  }
}