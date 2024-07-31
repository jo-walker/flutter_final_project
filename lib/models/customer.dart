import 'package:flutter/foundation.dart';

class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final String birthday;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.birthday,
  });
}