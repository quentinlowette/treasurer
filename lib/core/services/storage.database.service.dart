import 'package:sqflite/sqflite.dart';
import 'package:treasurer/core/database/dao/operation.dao.dart';
import 'package:treasurer/core/database/database_provider.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// An implementation of the storage service using an sqllite database.
class DatabaseStorageService extends StorageService {
  // The link to the operations' table via its DAO.
  OperationDao operationDao = OperationDao();

  @override
  Future<int> addOperation(Operation operation) async {
    // Fetches the database.
    final Database database = await DatabaseProvider.instance.database;

    // Inserts in the database the given operation, replace if conflict.
    return await database.insert(
        operationDao.tableName, operationDao.toMap(operation),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<bool> deleteOperation(Operation operation) async {
    // Fetches the database.
    final Database database = await DatabaseProvider.instance.database;

    // Deletes from the operations table the given operation.
    int affectedRows = await database.delete(operationDao.tableName,
        where: "${operationDao.id} = ?", whereArgs: [operation.id]);

    // Returns success status.
    return affectedRows != 0;
  }

  @override
  Future<List<Operation>> getOperations() async {
    // Fetches the database.
    final Database database = await DatabaseProvider.instance.database;

    // Fetches the content of the operations table.
    final List<Map<String, dynamic>> result = await database
        .query(operationDao.tableName, orderBy: operationDao.date + " DESC");

    // Generates a list of operations from a list of map.
    return List.generate(
        result.length, (index) => operationDao.fromMap(result[index]));
  }

  @override
  Future<List<double>> getAmounts() async {
    // Fetches the database.
    final Database database = await DatabaseProvider.instance.database;

    // Fetches the bank amount.
    final List<Map<String, dynamic>> bankResult = await database.rawQuery("""
      SELECT ${operationDao.source},
             ${operationDao.destination},
             SUM(tmp) as sum
      FROM (
        SELECT ${operationDao.source},
               ${operationDao.destination},
               SUM(${operationDao.amount}) as tmp
        FROM ${operationDao.tableName}
        WHERE ${operationDao.source} = ${ActorType.bank.index}
           OR ${operationDao.destination} = ${ActorType.bank.index}
        GROUP BY ${operationDao.source}
      )
      GROUP BY ${operationDao.destination}
    """);

    double bankExpense;
    double bankIncome;

    if (bankResult.length == 0) {
      // If there is no result from the database.
      bankExpense = 0.0;
      bankIncome = 0.0;
    } else if (bankResult.length == 1) {
      // If there is only 1 result from the database.
      Map<String, dynamic> result = bankResult[0];
      bankExpense = result[operationDao.source] == ActorType.bank.index
          ? result['sum']
          : 0.0;
      bankIncome = result[operationDao.destination] == ActorType.bank.index
          ? result['sum']
          : 0.0;
    } else {
      // If there is at least 2 results from the database.
      Map<String, dynamic> result1 = bankResult[0];
      Map<String, dynamic> result2 = bankResult[1];
      bankExpense = result1[operationDao.source] == ActorType.bank.index
          ? result1['sum']
          : result2['sum'];
      bankIncome = result1[operationDao.destination] == ActorType.bank.index
          ? result1['sum']
          : result2['sum'];
    }

    double bankTotal = bankIncome - bankExpense;

    // Fetches the cash amount.
    final List<Map<String, dynamic>> cashResult = await database.rawQuery("""
      SELECT ${operationDao.source}, ${operationDao.destination}, SUM(tmp) as sum
      FROM (
        SELECT ${operationDao.source}, ${operationDao.destination}, SUM(${operationDao.amount}) as tmp
        FROM ${operationDao.tableName}
        WHERE ${operationDao.source} = ${ActorType.cash.index}
           OR ${operationDao.destination} = ${ActorType.cash.index}
        GROUP BY ${operationDao.source}
      )
      GROUP BY ${operationDao.destination}
    """);

    double cashExpense;
    double cashIncome;

    if (cashResult.length == 0) {
      // If there is no result from the database.
      cashExpense = 0.0;
      cashIncome = 0.0;
    } else if (cashResult.length == 1) {
      // If there is only 1 result from the database.
      Map<String, dynamic> result = cashResult[0];
      cashExpense = result[operationDao.source] == ActorType.cash.index
          ? result['sum']
          : 0.0;
      cashIncome = result[operationDao.destination] == ActorType.cash.index
          ? result['sum']
          : 0.0;
    } else {
      // If there is at least 2 results from the database.
      Map<String, dynamic> result1 = cashResult[0];
      Map<String, dynamic> result2 = cashResult[1];
      cashExpense = result1[operationDao.source] == ActorType.cash.index
          ? result1['sum']
          : result2['sum'];
      cashIncome = result1[operationDao.destination] == ActorType.cash.index
          ? result1['sum']
          : result2['sum'];
    }

    double cashTotal = cashIncome - cashExpense;

    List<double> amounts = [bankTotal + cashTotal, bankTotal, cashTotal];
    return amounts;
  }

  @override
  Future<bool> updateOperation(Operation operation) async {
    // Fetches the database.
    final Database database = await DatabaseProvider.instance.database;

    // Updates in the database the given operation.
    int affectedRows = await database.update(
        operationDao.tableName, operationDao.toMap(operation),
        where: "${operationDao.id} = ?", whereArgs: [operation.id]);

    // Returns success status.
    return affectedRows != 0;
  }
}
