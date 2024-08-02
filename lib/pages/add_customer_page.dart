import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppLocalizations.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';

class AddCustomerPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('add_customer') ?? 'Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('first_name') ?? 'First Name',
                ),                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('enter_first_name') ?? 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('last_name') ?? 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('enter_last_name') ?? 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('address') ?? 'Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate('enter_address') ?? 'Please enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthdayController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate('birthday') ?? 'Birthday',
                ),
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
                    final customer = Customer(
                      id: null,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      address: _addressController.text,
                      birthday: _birthdayController.text,
                    );
                    customerProvider.addCustomer(customer);
                    Navigator.pop(context);
                  }
                },
                child: Text(AppLocalizations.of(context)!.translate('add_customer') ?? 'Add Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}