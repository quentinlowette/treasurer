import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treasurer/core/database/dao/dao.dart';
import 'package:treasurer/core/database/dao/operation.dao.dart';

/// Helper class for the database management
///
/// It is a Singleton that holds a reference to the database.
class DatabaseProvider {
  /// Database name
  static final String _databaseName = "treasurer.db";

  /// Database version number
  static final int _databaseVersion = 1;

  /// Tables definition
  static final List<Dao> tables = [OperationDao()];

  /// Instance of this class
  static final DatabaseProvider instance =
      DatabaseProvider._privateConstructor();

  /// Database instance
  static Database _database;

  /// Getter for the database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initInstance();
    return _database;
  }

  /// Private constructor
  DatabaseProvider._privateConstructor();

  /// Opens the database
  Future<Database> _initInstance() async {
    // Construct path (/data/user/0/com.example.treasurer/app_flutter/)
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);

    // Opens the database (No need to close because only one DB)
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  /// Creates the tables of the database
  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    for (Dao dao in tables) {
      batch.execute("DROP TABLE IF EXISTS ${dao.tableName}");
      batch.execute(dao.createTableQuery);
    }
    await batch.commit();
  }
}
