import 'package:flutter/foundation.dart';
import '../models/customer.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  void addCustomer(Customer customer) {
    _customers.add(customer);
    notifyListeners();
  }

  void updateCustomer(Customer customer) {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
      notifyListeners();
    }
  }

  void deleteCustomer(String id) {
    _customers.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}