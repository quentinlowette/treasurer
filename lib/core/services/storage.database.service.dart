import 'package:sqflite/sqflite.dart';
import 'package:treasurer/core/database/dao/operation.dao.dart';
import 'package:treasurer/core/database/databaseProvider.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// Implementation of the storage service using an sqllite database
class DatabaseStorageService extends StorageService {
  ///
  OperationDao operationDao = OperationDao();

  @override
  Future<int> addOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Inserts in the database the given operation, replace if conflict
    return await db.insert(
        operationDao.tableName, operationDao.toMap(operation),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<bool> deleteOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Deletes from the operations table the given operation
    int rowsAffected = await db.delete(operationDao.tableName,
        where: "${operationDao.id} = ?", whereArgs: [operation.id]);

    // Returns success status
    return rowsAffected != 0;
  }

  @override
  Future<List<Operation>> getOperations() async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Fetches the content of the operations table
    final List<Map<String, dynamic>> result =
        await db.query(operationDao.tableName);

    // Generates a list of operations from a list of map
    return List.generate(
        result.length, (index) => operationDao.fromMap(result[index]));
  }

  @override
  Future<List<double>> getAmounts() async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Fetches the bank amount
    final List<Map<String, dynamic>> bankResult = await db.rawQuery("""
      SELECT ${operationDao.src}, SUM(${operationDao.amount}) AS sum
      FROM ${operationDao.tableName}
      WHERE (${operationDao.src} = ${Actor.bank.index}) OR
            (${operationDao.dst} = ${Actor.bank.index})
      GROUP BY ${operationDao.src}
    """);

    double bankExpense = bankResult.length >= 1 ? bankResult[0]['sum'] : 0.0;
    double bankIncome = bankResult.length == 2 ? bankResult[1]['sum'] : 0.0;
    double bank = bankIncome - bankExpense;

    // Fetches the bank amount
    final List<Map<String, dynamic>> cashResult = await db.rawQuery("""
      SELECT ${operationDao.src}, SUM(${operationDao.amount}) AS sum
      FROM ${operationDao.tableName}
      WHERE (${operationDao.src} = ${Actor.cash.index}) OR
            (${operationDao.dst} = ${Actor.cash.index})
      GROUP BY ${operationDao.src}
    """);

    double cashExpense = cashResult.length >= 1 ? cashResult[0]['sum'] : 0.0;
    double cashIncome = cashResult.length == 2 ? cashResult[1]['sum'] : 0.0;
    double cash = cashIncome - cashExpense;

    List<double> amounts = [bank + cash, bank, cash];
    return amounts;
  }

  @override
  Future<bool> updateOperation(Operation operation) async {
    // Fetches the database
    final Database db = await DatabaseProvider.instance.database;

    // Updates in the database the given operation
    int rowsAffected = await db.update(
        operationDao.tableName, operationDao.toMap(operation),
        where: "${operationDao.id} = ?", whereArgs: [operation.id]);

    // Returns success status
    return rowsAffected != 0;
  }
}
