import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';
import 'add_customer_page.dart';
import 'edit_customer_page.dart';

class CustomerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
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
                        builder: (context) => CustomerDetailPage(customer: customer),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCustomerPage()),
                );
              },
              child: Text('Add Customer'),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerDetailPage extends StatelessWidget {
  final Customer customer;

  CustomerDetailPage({required this.customer});

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              customerProvider.deleteCustomer(customer.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${customer.firstName}'),
            Text('Last Name: ${customer.lastName}'),
            Text('Address: ${customer.address}'),
            Text('Birthday: ${customer.birthday}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCustomerPage(customer: customer),
                  ),
                );
              },
              child: Text('Edit Customer'),
            ),
          ],
        ),
      ),
    );
  }
}