import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'flight.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Add this import

class FlightRepository extends ChangeNotifier {
  late Database _database;

  Future<void> initDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'flights_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE flights(id INTEGER PRIMARY KEY AUTOINCREMENT, departureCity TEXT, destinationCity TEXT, departureTime TEXT, arrivalTime TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Flight>> getFlights() async {
    final List<Map<String, dynamic>> maps = await _database.query('flights');

    return List.generate(maps.length, (i) {
      return Flight(
        id: maps[i]['id'],
        departureCity: maps[i]['departureCity'],
        destinationCity: maps[i]['destinationCity'],
        departureTime: maps[i]['departureTime'],
        arrivalTime: maps[i]['arrivalTime'],
      );
    });
  }

  Future<void> addFlight(Flight flight) async {
    await _database.insert(
      'flights',
      flight.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> updateFlight(Flight flight) async {
    await _database.update(
      'flights',
      flight.toMap(),
      where: 'id = ?',
      whereArgs: [flight.id],
    );
    notifyListeners();
  }

  Future<void> deleteFlight(int id) async {
    await _database.delete(
      'flights',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }
}
