import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../models/airplane.dart';
import '../dao/airplane_dao.dart';
import 'dart:async'; // Add this line

part 'app_database.g.dart';

@Database(version: 1, entities: [Airplane])
abstract class AppDatabase extends FloorDatabase {
  AirplaneDAO get airplaneDAO;
}
