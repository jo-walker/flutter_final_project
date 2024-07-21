import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customer.dart';
import 'pages/customer_page.dart';
// import 'pages/airplane_page.dart';
// import 'pages/flight_page.dart';
// import 'pages/reservation_page.dart';

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
        initialRoute: '/',
        routes: {
          '/': (context) => MainPage(),
          '/customer': (context) => CustomerListPage(),
          // '/airplane': (context) => AirplaneListPage(),
          // '/flight': (context) => FlightsListPage(),
          // '/reservation': (context) => ReservationPage(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/customer');
              },
              child: Text('Customer List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/airplane');
              },
              child: Text('Airplane List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/flight');
              },
              child: Text('Flights List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reservation');
              },
              child: Text('Reservation Page'),
            ),
          ],
        ),
      ),
    );
  }
}
