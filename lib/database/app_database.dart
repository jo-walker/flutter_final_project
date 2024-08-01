import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../models/customer.dart';
import '../dao/customer_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Customer])
abstract class AppDatabase extends FloorDatabase {
  CustomerDAO get customerDAO;
}
