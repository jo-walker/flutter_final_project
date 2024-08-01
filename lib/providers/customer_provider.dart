import 'package:flutter/material.dart';
import '../dao/customer_dao.dart';
import '../database/app_database.dart';
import '../models/customer.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  late CustomerDAO _customerDAO;
  String _error = '';

  List<Customer> get customers => _customers;
  String get error => _error;

  CustomerProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _customerDAO = database.customerDAO;
    await _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      _customers = await _customerDAO.findAllCustomers();
    } catch (e) {
      _error = 'Failed to load customers: $e';
    }
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      await _customerDAO.insertCustomer(customer);
      await _loadCustomers();
    } catch (e) {
      _error = 'Failed to add customer: $e';
      notifyListeners();
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _customerDAO.updateCustomer(customer);
      await _loadCustomers();
    } catch (e) {
      _error = 'Failed to update customer: $e';
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await _customerDAO.deleteCustomer(Customer(id: id, firstName: '', lastName: '', address: '', birthday: ''));
      await _loadCustomers();
    } catch (e) {
      _error = 'Failed to delete customer: $e';
      notifyListeners();
    }
  }
}