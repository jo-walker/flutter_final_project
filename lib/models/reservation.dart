import 'package:floor/floor.dart';

/// The `Reservation` class represents a reservation entity.
@Entity(tableName: 'reservations')
class Reservation {
  /// The unique ID of the reservation.
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// The name of the customer.
  final String customerName;

  /// The flight number.
  final String flightNumber;

  /// The name of the reservation.
  final String reservationName;

  /// The date of the reservation.
  final DateTime date;

  /// Constructs a `Reservation`.
  Reservation({
    this.id,
    required this.customerName,
    required this.flightNumber,
    required this.reservationName,
    required this.date,
  });
}
