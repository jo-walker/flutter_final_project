import 'package:flutter/material.dart';
import '../dao/airplane_dao.dart';
import '../database/app_database.dart';
import '../models/airplane.dart';

class AirplaneProvider with ChangeNotifier {
  List<Airplane> _airplanes = [];
  late AirplaneDAO _airplaneDAO;
  String _error = '';

  List<Airplane> get airplanes => _airplanes;
  String get error => _error;

  AirplaneProvider(AirplaneDAO airplaneDAO) {
    _airplaneDAO = airplaneDAO;
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      await _loadAirplanes();
    } catch (e) {
      _error = 'Failed to initialize database: $e';
      notifyListeners();
    }
  }

  Future<void> _loadAirplanes() async {
    try {
      _airplanes = await _airplaneDAO.findAllAirplanes();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load airplanes: $e';
      notifyListeners();
    }
  }

  Future<void> addAirplane(Airplane airplane) async {
    try {
      await _airplaneDAO.insertAirplane(airplane);
      await _loadAirplanes();
    } catch (e) {
      _error = 'Failed to add airplane: $e';
      notifyListeners();
    }
  }

  Future<void> updateAirplane(Airplane airplane) async {
    try {
      await _airplaneDAO.updateAirplane(airplane);
      await _loadAirplanes();
    } catch (e) {
      _error = 'Failed to update airplane: $e';
      notifyListeners();
    }
  }

  Future<void> deleteAirplane(int id) async {
    try {
      Airplane? airplaneToDelete = _airplanes.firstWhere(
              (airplane) => airplane.id == id,
          orElse: () => Airplane(id: 0, type: 'Unknown', passengerCount: 0, maxSpeed: 0.0, range: 0.0)
      );



      if (airplaneToDelete != null) {
        await _airplaneDAO.deleteAirplane(airplaneToDelete);
        await _loadAirplanes(); // Refresh list after deletion
      } else {
        _error = 'Airplane not found for deletion';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to delete airplane: $e';
      notifyListeners();
    }
  }
}
