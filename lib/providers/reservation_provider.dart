import 'package:flutter/material.dart';
import '../dao/reservation_dao.dart';
import '../database/app_database_reservation.dart';
import '../models/reservation.dart';

class ReservationProvider with ChangeNotifier {
  List<Reservation> _reservations = [];
  late ReservationDAO _reservationDAO;
  String _error = '';

  List<Reservation> get reservations => _reservations;
  String get error => _error;

  ReservationProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _reservationDAO = database.reservationDAO;
    await _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      _reservations = await _reservationDAO.findAllReservations();
    } catch (e) {
      _error = 'Failed to load reservations: $e';
    }
    notifyListeners();
  }

  Future<void> addReservation(Reservation reservation) async {
    try {
      await _reservationDAO.insertReservation(reservation);
      await _loadReservations();
    } catch (e) {
      _error = 'Failed to add reservation: $e';
      notifyListeners();
    }
  }

  Future<void> updateReservation(Reservation reservation) async {
    try {
      await _reservationDAO.updateReservation(reservation);
      await _loadReservations();
    } catch (e) {
      _error = 'Failed to update reservation: $e';
      notifyListeners();
    }
  }

  Future<void> deleteReservation(Reservation reservation) async {
    try {
      await _reservationDAO.deleteReservation(reservation);
      await _loadReservations();
    } catch (e) {
      _error = 'Failed to delete reservation: $e';
      notifyListeners();
    }
  }

  List<Reservation> searchReservations(String query) {
    return _reservations.where((reservation) {
      return reservation.customerName.toLowerCase().contains(query.toLowerCase()) ||
          reservation.reservationName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
