import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
@entity
class Customer {
  @primaryKey
  final int? id; //means this field is nullable
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