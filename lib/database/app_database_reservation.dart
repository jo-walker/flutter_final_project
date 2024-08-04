import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../models/reservation.dart';
import '../dao/reservation_dao.dart';
import '../converters/date_time_converter.dart';
import 'dart:async';

part 'app_database_reservation.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Reservation])

abstract class AppDatabase extends FloorDatabase {
  ReservationDAO get reservationDAO;
}
