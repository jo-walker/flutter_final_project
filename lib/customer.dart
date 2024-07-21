import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  List<Customer> get customers => _customers;

  CustomerProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
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
      await _fetchCustomers();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _fetchCustomers() async {
    try {
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
      notifyListeners();
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      await _database.insert(
        'customers',
        customer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _fetchCustomers();
    } catch (e) {
      print('Error adding customer: $e');
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _database.update(
        'customers',
        customer.toMap(),
        where: 'id = ?',
        whereArgs: [customer.id],
      );
      await _fetchCustomers();
    } catch (e) {
      print('Error updating customer: $e');
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await _database.delete(
        'customers',
        where: 'id = ?',
        whereArgs: [id],
      );
      await _fetchCustomers();
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }
}
