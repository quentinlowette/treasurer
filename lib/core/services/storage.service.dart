import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treasurer/core/models/operation.m.dart';

/// Storage Service
abstract class StorageService {
  /// Adds an operation to the storage
  Future<void> addOperation(Operation operation);

  /// Deletes the given operation from storage
  Future<void> deleteOperation(Operation operation);

  /// Returns the stored list of operations
  Future<List<Operation>> getOperations();

  /// Returns the total, cash and bank amounts based on the operations
  Future<List<double>> getAmounts();

  /// Updates the given operation in storage
  Future<void> updateOperation(Operation operation);
}

/// Fake implementation of the storage service
class FakeStorageService extends StorageService {
  @override
  Future<void> addOperation(Operation operation) {
    // do nothing
    return null;
  }

  @override
  Future<void> deleteOperation(Operation operation) {
    // do nothing
    return null;
  }

  @override
  Future<List<Operation>> getOperations() async {
    Operation op1 = Operation(
        amount: 200.0,
        date: DateTime.utc(2020, 2, 20, 10, 00),
        description: "Fake operation 1",
        id: 1,
        isCash: false,
        receiptPhotoPath: "/fake/path/to/receipt/1");
    Operation op2 = Operation(
        amount: -100.0,
        date: DateTime.utc(2020, 2, 20, 12, 00),
        description: "Fake operation 2",
        id: 2,
        isCash: false,
        receiptPhotoPath: "/fake/path/to/receipt/2");
    Operation op3 = Operation(
        amount: 50.0,
        date: DateTime.utc(2020, 2, 21, 10, 00),
        description: "Fake operation 3",
        id: 3,
        isCash: true,
        receiptPhotoPath: "/fake/path/to/receipt/3");
    Operation op4 = Operation(
        amount: 200.0,
        date: DateTime.utc(2020, 2, 21, 12, 00),
        description: "Fake operation 4",
        id: 4,
        isCash: false,
        receiptPhotoPath: "/fake/path/to/receipt/1");
    Operation op5 = Operation(
        amount: -100.0,
        date: DateTime.utc(2020, 2, 21, 13, 00),
        description: "Fake operation 5",
        id: 5,
        isCash: false,
        receiptPhotoPath: "/fake/path/to/receipt/2");
    Operation op6 = Operation(
        amount: 50.0,
        date: DateTime.utc(2020, 2, 21, 14, 00),
        description: "Fake operation 6",
        id: 6,
        isCash: true,
        receiptPhotoPath: "/fake/path/to/receipt/3");
    Operation op7 = Operation(
        amount: -100.0,
        date: DateTime.utc(2020, 2, 21, 15, 00),
        description: "Fake operation 7",
        id: 7,
        isCash: false,
        receiptPhotoPath: "/fake/path/to/receipt/2");
    Operation op8 = Operation(
        amount: 50.0,
        date: DateTime.utc(2020, 2, 21, 16, 00),
        description: "Fake operation 8",
        id: 8,
        isCash: true,
        receiptPhotoPath: "/fake/path/to/receipt/3");
    List<Operation> operations = List<Operation>();
    operations.add(op1);
    operations.add(op2);
    operations.add(op3);
    operations.add(op4);
    operations.add(op5);
    operations.add(op6);
    operations.add(op7);
    operations.add(op8);

    await Future.delayed(Duration(seconds: 3), () => null);
    return operations;
  }

  @override
  Future<List<double>> getAmounts() async {
    List<double> amounts = List<double>();

    amounts.add(250.0);
    amounts.add(100.0);
    amounts.add(150.0);

    await Future.delayed(Duration(seconds: 3), () => null);
    return amounts;
  }

  @override
  Future<void> updateOperation(Operation operation) {
    // do nothing
    return null;
  }
}

// TODO: In the future, maybe have a better structure that would be able to store multiple tables in an easy and manageable way
/// Database implementation of the storage service
class DatabaseStorageService extends StorageService {
  @override
  Future<void> addOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseHelper.instance.database;

    // Inserts in the database the given operation, replace if conflict
    await db.insert(DatabaseHelper.operationsTable, operation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseHelper.instance.database;

    // Deletes from the operations table the given operation
    await db.delete(DatabaseHelper.operationsTable,
        where: "${DatabaseHelper.otColumnId} = ?", whereArgs: [operation.id]);
  }

  @override
  Future<List<Operation>> getOperations() async {
    // Fetches the database
    final Database db = await DatabaseHelper.instance.database;

    // Fetches the content of the operations table
    final List<Map<String, dynamic>> result =
        await db.query(DatabaseHelper.operationsTable);

    // Generates a list of operations from a list of map
    return List.generate(
        result.length,
        (index) => Operation(
              amount: result[index][DatabaseHelper.otColumnAmount],
              date: result[index][DatabaseHelper.otColumnDate],
              description: result[index][DatabaseHelper.otColumnDescription],
              id: result[index][DatabaseHelper.otColumnId],
              isCash: result[index][DatabaseHelper.otColumnIsCash],
              receiptPhotoPath: result[index]
                  [DatabaseHelper.otColumnReceiptPhotoPath],
            ));
  }

  @override
  Future<List<double>> getAmounts() async {
    // Fetches the database
    final Database db =  await DatabaseHelper.instance.database;

    // Fetches the bank amount
    final List<Map<String, dynamic>> bankResult = await db.rawQuery('''
      SELECT SUM(${DatabaseHelper.otColumnAmount}) as total
      FROM ${DatabaseHelper.operationsTable}
      WHERE ${DatabaseHelper.otColumnIsCash} = 0
    ''');

    final double bank = bankResult[0]['total'];

    // Fetches the bank amount
    final List<Map<String, dynamic>> cashResult = await db.rawQuery('''
      SELECT SUM(${DatabaseHelper.otColumnAmount}) as total
      FROM ${DatabaseHelper.operationsTable}
      WHERE ${DatabaseHelper.otColumnIsCash} = 1
    ''');

    final double cash = cashResult[0]['total'];

    List<double> amounts = [
      bank + cash,
      bank,
      cash
    ];
    return amounts;
  }

  @override
  Future<void> updateOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseHelper.instance.database;

    // Updates in the database the given operation
    await db.update(DatabaseHelper.operationsTable, operation.toMap(),
        where: "${DatabaseHelper.otColumnId} = ?", whereArgs: [operation.id]);
  }
}

/// Helper class for the database management
///
/// It is a Singleton that holds a reference to the database.
/// It also exposes the table and columns names.
class DatabaseHelper {
  /// Database name
  static final String _databaseName = "Treasurer.db";

  /// Database version number
  static final int _databaseVersion = 1;

  /// Table name
  static final String operationsTable = "operations";

  /// Columns names
  static final String otColumnAmount = "amount";
  static final String otColumnDate = "date";
  static final String otColumnDescription = "description";
  static final String otColumnId = "id";
  static final String otColumnIsCash = "isCash";
  static final String otColumnReceiptPhotoPath = "receiptPhotoPath";

  /// Instance of this class
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  /// Database instance
  static Database _database;

  /// Private constructor
  DatabaseHelper._privateConstructor();

  /// Getter for the database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initInstance();
    return _database;
  }

  /// Opens the database
  Future<Database> _initInstance() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  /// Creates the table of the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $operationsTable (
        id INTEGER PRIMARY KEY AUTO_INCREMENT,
        amount DOUBLE NOT NULL,
        isCash BOOLEAN NOT NULL,
        date DATE NOT NULL,
        description VARCHAR(255) NOT NULL,
        receiptPhotoPath VARCHAR(255) NOT NULL
      )
    ''');
  }
}
