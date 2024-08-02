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
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _airplaneDAO = database.airplaneDAO;
    await _loadAirplanes();
  }

  Future<void> _loadAirplanes() async {
    try {
      _airplanes = await _airplaneDAO.findAllAirplanes();
    } catch (e) {
      _error = 'Failed to load airplanes: $e';
    }
    notifyListeners();
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
      await _airplaneDAO.deleteAirplane(Airplane(id: id, type: '', passengerCount: 0, maxSpeed: 0, range: 0));
      await _loadAirplanes();
    } catch (e) {
      _error = 'Failed to delete airplane: $e';
      notifyListeners();
    }
  }
}
