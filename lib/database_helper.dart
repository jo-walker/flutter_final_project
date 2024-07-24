import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit(); // Initialize sqflite FFI
    databaseFactory = databaseFactoryFfi; // Set database factory to FFI

    return await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE flights (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              departureCity TEXT,
              destinationCity TEXT,
              departureTime TEXT,
              arrivalTime TEXT
            )
          ''');
        },
      ),
    );
  }
}
