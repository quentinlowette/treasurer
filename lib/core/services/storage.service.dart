import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treasurer/core/models/operation.m.dart';

/// Storage Service
abstract class StorageService {
  Future<void> addOperation(Operation operation);
  Future<void> deleteOperation(Operation operation);
  Future<List<Operation>> getOperations();
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
    List<Operation> operations = List<Operation>();
    operations.add(op1);
    operations.add(op2);
    operations.add(op3);

    await Future.delayed(Duration(seconds: 3), () => null);
    return operations;
  }

  @override
  Future<void> updateOperation(Operation operation) {
    // do nothing
    return null;
  }
}

/// Database implementation of the storage service
class DatabaseStorageService extends StorageService {
  @override
  Future<void> addOperation(Operation operation) async {
    final Database db = await DatabaseHelper.instance.database;

    await db.insert(DatabaseHelper.operationsTable, operation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteOperation(Operation operation) async {
    final Database db = await DatabaseHelper.instance.database;

    await db.delete(DatabaseHelper.operationsTable,
        where: "${DatabaseHelper.otColumnId} = ?", whereArgs: [operation.id]);
  }

  @override
  Future<List<Operation>> getOperations() async {
    final Database db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> result =
        await db.query(DatabaseHelper.operationsTable);

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
  Future<void> updateOperation(Operation operation) async {
    final Database db = await DatabaseHelper.instance.database;

    await db.update(DatabaseHelper.operationsTable, operation.toMap(),
        where: "${DatabaseHelper.otColumnId} = ?", whereArgs: [operation.id]);
  }
}

class DatabaseHelper {
  static final String _databaseName = "Treasurer.db";
  static final int _databaseVersion = 1;

  static final String operationsTable = "operations";
  static final String otColumnAmount = "amount";
  static final String otColumnDate = "date";
  static final String otColumnDescription = "description";
  static final String otColumnId = "id";
  static final String otColumnIsCash = "isCash";
  static final String otColumnReceiptPhotoPath = "receiptPhotoPath";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initInstance();
    return _database;
  }

  Future<Database> _initInstance() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

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
