import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customer.dart';

class CustomerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: customerProvider.customers.length,
              itemBuilder: (context, index) {
                final customer = customerProvider.customers[index];
                return ListTile(
                  title: Text('${customer.firstName} ${customer.lastName}'),
                  subtitle: Text(customer.address),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerFormPage(customer: customer),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerFormPage(),
                ),
              );
            },
            child: Text('Add Customer'),
          ),
        ],
      ),
    );
  }
}

class CustomerFormPage extends StatefulWidget {
  final Customer? customer;

  CustomerFormPage({this.customer});

  @override
  _CustomerFormPageState createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _address;
  late String _birthday;
  late bool _copyLastCustomer;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _firstName = widget.customer!.firstName;
      _lastName = widget.customer!.lastName;
      _address = widget.customer!.address;
      _birthday = widget.customer!.birthday;
    } else {
      _firstName = '';
      _lastName = '';
      _address = '';
      _birthday = '';
      _copyLastCustomer = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (widget.customer == null)
                CheckboxListTile(
                  title: Text('Copy from last customer'),
                  value: _copyLastCustomer,
                  onChanged: (bool? value) async {
                    setState(() {
                      _copyLastCustomer = value ?? false;
                    });
                    if (_copyLastCustomer) {
                      Customer? lastCustomer = await customerProvider.getLastCustomerData();
                      if (lastCustomer != null) {
                        setState(() {
                          _firstName = lastCustomer.firstName;
                          _lastName = lastCustomer.lastName;
                          _address = lastCustomer.address;
                          _birthday = lastCustomer.birthday;
                        });
                      }
                    } else {
                      setState(() {
                        _firstName = '';
                        _lastName = '';
                        _address = '';
                        _birthday = '';
                      });
                    }
                  },
                ),
              TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _firstName = value!;
                },
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lastName = value!;
                },
              ),
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              TextFormField(
                initialValue: _birthday,
                decoration: InputDecoration(labelText: 'Birthday'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a birthday';
                  }
                  return null;
                },
                onSaved: (value) {
                  _birthday = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.customer == null) {
                      Customer newCustomer = Customer(
                        firstName: _firstName,
                        lastName: _lastName,
                        address: _address,
                        birthday: _birthday,
                      );
                      customerProvider.addCustomer(newCustomer);
                      customerProvider.saveLastCustomerData(newCustomer);
                    } else {
                      Customer updatedCustomer = Customer(
                        id: widget.customer!.id,
                        firstName: _firstName,
                        lastName: _lastName,
                        address: _address,
                        birthday: _birthday,
                      );
                      customerProvider.updateCustomer(updatedCustomer);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.customer == null ? 'Add' : 'Update'),
              ),
              if (widget.customer != null)
                ElevatedButton(
                  onPressed: () {
                    customerProvider.deleteCustomer(widget.customer!.id!);
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}