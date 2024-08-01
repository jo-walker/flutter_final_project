import 'package:floor/floor.dart';
import '../models/customer.dart';

@dao
abstract class CustomerDAO {
  @Query('SELECT * FROM Customer')
  Future<List<Customer>> findAllCustomers();

  @insert
  Future<void> insertCustomer(Customer customer);

  @update
  Future<void> updateCustomer(Customer customer);

  @delete
  Future<void> deleteCustomer(Customer customer);
}
