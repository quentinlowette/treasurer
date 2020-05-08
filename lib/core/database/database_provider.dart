import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treasurer/core/database/dao/dao.dart';
import 'package:treasurer/core/database/dao/operation.dao.dart';

/// An helper class for the database management.
///
/// DatabaseProvider is a singleton that holds a reference to the database.
/// It is responsible to create the table on the database creation.
class DatabaseProvider {
  /// The name of the database.
  static final String _name = "treasurer.db";

  /// The version number of the database.
  static final int _version = 1;

  /// The definition of the database's tables.
  static final List<Dao> _tables = [OperationDao()];

  /// An instance of this class.
  static final DatabaseProvider instance =
      DatabaseProvider._privateConstructor();

  /// The database instance.
  static Database _database;

  /// Returns the single database instance.
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initInstance();
    return _database;
  }

  DatabaseProvider._privateConstructor();

  /// Initializes the database and creates it if necessary.
  Future<Database> _initInstance() async {
    // Constructs path
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _name);

    // Opens the database (No need to close because only one DB)
    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  /// Creates the tables of the database.
  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    for (Dao dao in _tables) {
      batch.execute("DROP TABLE IF EXISTS ${dao.tableName}");
      batch.execute(dao.creationQuery);
    }
    await batch.commit();
  }
}
