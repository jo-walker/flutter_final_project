import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/customer_provider.dart';
import 'pages/customer_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerProvider(),
      child: MaterialApp(
        title: 'Final Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage(),
        routes: {
          '/customer': (context) => CustomerListPage(),
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/customer');
          },
          child: Text('Customer List'),
        ),
      ),
    );
  }
}