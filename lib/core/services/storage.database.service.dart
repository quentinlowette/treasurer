import 'package:sqflite/sqflite.dart';
import 'package:treasurer/core/database/dao/operation.dao.dart';
import 'package:treasurer/core/database/database_provider.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// Implementation of the storage service using an sqllite database
class DatabaseStorageService extends StorageService {
  // Link to the operations' table
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
        await db.query(operationDao.tableName, orderBy: operationDao.date + " DESC");

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
      SELECT ${operationDao.src}, ${operationDao.dst}, SUM(tmp) as sum
      FROM (
        SELECT ${operationDao.src}, ${operationDao.dst}, SUM(${operationDao.amount}) as tmp
        FROM ${operationDao.tableName}
        WHERE ${operationDao.src} = ${ActorType.bank.index}
           OR ${operationDao.dst} = ${ActorType.bank.index}
        GROUP BY ${operationDao.src}
      )
      GROUP BY ${operationDao.dst}
    """);

    double bankExpense;
    double bankIncome;

    if (bankResult.length == 0) {
      // No result from DB
      bankExpense = 0.0;
      bankIncome = 0.0;
    } else if (bankResult.length == 1) {
      // Only 1 result from DB
      Map<String, dynamic> result = bankResult[0];
      bankExpense = result[operationDao.src] == ActorType.bank.index ? result['sum'] : 0.0;
      bankIncome = result[operationDao.dst] == ActorType.bank.index ? result['sum'] : 0.0;
    } else {
      // At least 2 results from DB
      Map<String, dynamic> result1 = bankResult[0];
      Map<String, dynamic> result2 = bankResult[1];
      bankExpense = result1[operationDao.src] == ActorType.bank.index ? result1['sum'] : result2['sum'];
      bankIncome = result1[operationDao.dst] == ActorType.bank.index ? result1['sum'] : result2['sum'];
    }

    double bank = bankIncome - bankExpense;

    // Fetches the cash amount
    final List<Map<String, dynamic>> cashResult = await db.rawQuery("""
      SELECT ${operationDao.src}, ${operationDao.dst}, SUM(tmp) as sum
      FROM (
        SELECT ${operationDao.src}, ${operationDao.dst}, SUM(${operationDao.amount}) as tmp
        FROM ${operationDao.tableName}
        WHERE ${operationDao.src} = ${ActorType.cash.index}
           OR ${operationDao.dst} = ${ActorType.cash.index}
        GROUP BY ${operationDao.src}
      )
      GROUP BY ${operationDao.dst}
    """);

    double cashExpense;
    double cashIncome;

    if (cashResult.length == 0) {
      // No result from DB
      cashExpense = 0.0;
      cashIncome = 0.0;
    } else if (cashResult.length == 1) {
      // Only 1 result from DB
      Map<String, dynamic> result = cashResult[0];
      cashExpense = result[operationDao.src] == ActorType.cash.index ? result['sum'] : 0.0;
      cashIncome = result[operationDao.dst] == ActorType.cash.index ? result['sum'] : 0.0;
    } else {
      // At least 2 results from DB
      Map<String, dynamic> result1 = cashResult[0];
      Map<String, dynamic> result2 = cashResult[1];
      cashExpense = result1[operationDao.src] == ActorType.cash.index ? result1['sum'] : result2['sum'];
      cashIncome = result1[operationDao.dst] == ActorType.cash.index ? result1['sum'] : result2['sum'];
    }

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
