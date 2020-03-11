import 'package:treasurer/core/database/dao/dao.dart';
import 'package:treasurer/core/models/operation.m.dart';

/// Operation Data-Access Object
///
/// Middleware between a model and a database table
class OperationsDao extends Dao<Operation> {
  // Columns names
  final String id = "id";
  final String amount = "amount";
  final String isCash = "isCash";
  final String date = "date";
  final String description = "description";
  final String receiptPhotoPath = "receiptPhotoPath";

  // Constructor
  OperationsDao(){
    // Columns definition
    columnsDefinition = [
        [id, "INTEGER PRIMARY KEY AUTOINCREMENT"],
        [amount, "REAL NOT NULL"],
        [isCash, "INTEGER NOT NULL"],
        [date, "INTEGER NOT NULL"],
        [description, "TEXT NOT NULL"],
        [receiptPhotoPath, "TEXT"]
      ];

    // Table name
    tableName = "operations";
  }

  @override
  Operation fromMap(Map<String, dynamic> map) {
    return Operation(
        amount: map[amount],
        date: DateTime.fromMillisecondsSinceEpoch(map[date]),
        description: map[description],
        id: map[id],
        isCash: map[isCash] == 1,
        receiptPhotoPath: map[receiptPhotoPath]);
  }

  @override
  Map<String, dynamic> toMap(Operation operation) {
    return {
      amount: operation.amount,
      date: operation.date.millisecondsSinceEpoch,
      description: operation.description,
      isCash: operation.isCash ? 1 : 0,
      receiptPhotoPath: operation.receiptPhotoPath
    };
  }
}
