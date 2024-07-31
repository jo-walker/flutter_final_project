import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';

class EditCustomerPage extends StatelessWidget {
  final Customer customer;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();

  EditCustomerPage({required this.customer}) {
    _firstNameController.text = customer.firstName;
    _lastNameController.text = customer.lastName;
    _addressController.text = customer.address;
    _birthdayController.text = customer.birthday;
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(labelText: 'Birthday'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter birthday';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedCustomer = Customer(
                      id: customer.id,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      address: _addressController.text,
                      birthday: _birthdayController.text,
                    );
                    customerProvider.updateCustomer(updatedCustomer);
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
