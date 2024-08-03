import 'package:floor/floor.dart';
import '../converters/date_time_converter.dart';

@TypeConverters([DateTimeConverter])
@entity
class Reservation {
  @primaryKey
  final int? id;
  final String customerName;
  final String flightNumber;
  final String reservationName;
  final DateTime date;

  Reservation({
    this.id,
    required this.customerName,
    required this.flightNumber,
    required this.reservationName,
    required this.date,
  });
}
