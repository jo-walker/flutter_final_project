import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'flight_list_view.dart';
import 'add_flight_page.dart';
import 'update_flight_page.dart';
import 'flight_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Add this import
import 'flight.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite ffi for desktop platforms
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final flightRepository = FlightRepository();
  await flightRepository.initDatabase();

  runApp(MyApp(flightRepository: flightRepository));
}

class MyApp extends StatelessWidget {
  final FlightRepository flightRepository;

  MyApp({required this.flightRepository});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => flightRepository,
      child: MaterialApp(
        title: 'Final Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage(),
        routes: {
          '/add_flight': (context) => AddFlightPage(),
          '/update_flight': (context) => UpdateFlightPage(
            flight: ModalRoute.of(context)!.settings.arguments as Flight,
          ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerListPage()),
                );
              },
              child: Text('Customer List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AirplaneListPage()),
                );
              },
              child: Text('Airplane List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlightListView()),
                );
              },
              child: Text('Flights List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationPage()),
                );
              },
              child: Text('Reservation Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List Page'),
      ),
      body: Center(
        child: Text('Customer List Page Content'),
      ),
    );
  }
}

class AirplaneListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane List Page'),
      ),
      body: Center(
        child: Text('Airplane List Page Content'),
      ),
    );
  }
}

class ReservationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Page'),
      ),
      body: Center(
        child: Text('Reservation Page Content'),
      ),
    );
  }
}
