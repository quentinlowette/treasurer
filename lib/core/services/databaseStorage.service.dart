import 'package:sqflite/sqflite.dart';
import 'package:treasurer/core/database/dao/operations.dao.dart';
import 'package:treasurer/core/database/databaseProvider.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// Implementation of the storage service using an sqllite database
class DatabaseStorageService extends StorageService {
  ///
  OperationsDao operationsDao = OperationsDao();

  @override
  Future<int> addOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Inserts in the database the given operation, replace if conflict
    return await db.insert(
        operationsDao.tableName, operationsDao.toMap(operation),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Deletes from the operations table the given operation
    await db.delete(operationsDao.tableName,
        where: "${operationsDao.id} = ?", whereArgs: [operation.id]);
  }

  @override
  Future<List<Operation>> getOperations() async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Fetches the content of the operations table
    final List<Map<String, dynamic>> result =
        await db.query(operationsDao.tableName);

    // Generates a list of operations from a list of map
    return List.generate(
        result.length, (index) => operationsDao.fromMap(result[index]));
  }

  @override
  Future<List<double>> getAmounts() async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Fetches the bank amount
    final List<Map<String, dynamic>> bankResult = await db.rawQuery("""
      SELECT SUM(${operationsDao.amount}) as sum
      FROM ${operationsDao.tableName}
      WHERE ${operationsDao.isCash} = 0
    """);

    final double bank = bankResult[0]['sum'] ?? 0;

    // Fetches the bank amount
    final List<Map<String, dynamic>> cashResult = await db.rawQuery("""
      SELECT SUM(${operationsDao.amount}) as sum
      FROM ${operationsDao.tableName}
      WHERE ${operationsDao.isCash} = 1
    """);

    final double cash = cashResult[0]['sum'] ?? 0;

    List<double> amounts = [bank + cash, bank, cash];
    return amounts;
  }

  @override
  Future<void> updateOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Updates in the database the given operation
    await db.update(operationsDao.tableName, operationsDao.toMap(operation),
        where: "${operationsDao.id} = ?", whereArgs: [operation.id]);
  }
}
