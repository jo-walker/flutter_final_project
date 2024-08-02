import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppLocalizations.dart';
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
        title: Text(AppLocalizations.of(context)!.translate('edit_customer') ?? 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('first_name') ?? 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('enter_first_name') ?? 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('last_name') ?? 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('enter_last_name') ?? 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('address') ?? 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('enter_address') ?? 'Please enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('birthday') ?? 'Birthday'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('enter_birthday') ?? 'Please enter birthday';
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
                child: Text(AppLocalizations.of(context)!.translate('update_customer') ?? 'Update Customer')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
