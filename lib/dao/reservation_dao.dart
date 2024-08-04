import 'package:floor/floor.dart';
import '../models/reservation.dart';

@dao
abstract class ReservationDAO {
  @Query('SELECT * FROM Reservation')
  Future<List<Reservation>> findAllReservations();

  @insert
  Future<void> insertReservation(Reservation reservation);

  @update

  Future<void> updateReservation(Reservation reservation);

  @delete
  Future<void> deleteReservation(Reservation reservation);
}
