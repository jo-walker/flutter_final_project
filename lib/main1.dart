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
        title: 'Airline Flights',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FlightListView(),
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
