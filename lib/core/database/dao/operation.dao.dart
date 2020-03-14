import 'package:treasurer/core/database/dao/dao.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';

/// Operation Data-Access Object
///
/// Middleware between a model and a database table
class OperationDao extends Dao<Operation> {
  // Columns names
  final String id = "id";
  final String amount = "amount";
  final String src = "source";
  final String dst = "destination";
  final String date = "date";
  final String description = "description";
  final String receiptPhotoPath = "receiptPhotoPath";

  // Constructor
  OperationDao(){
    // Columns definition
    columnsDefinition = [
        [id, "INTEGER PRIMARY KEY AUTOINCREMENT"],
        [amount, "REAL NOT NULL"],
        [src, "INTEGER NOT NULL"],
        [dst, "INTEGER NOT NULL"],
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
        src: Actor.values[map[src]],
        dst: Actor.values[map[dst]],
        receiptPhotoPath: map[receiptPhotoPath]);
  }

  @override
  Map<String, dynamic> toMap(Operation operation) {
    return {
      amount: operation.amount,
      date: operation.date.millisecondsSinceEpoch,
      description: operation.description,
      src: operation.src.index,
      dst: operation.dst.index,
      receiptPhotoPath: operation.receiptPhotoPath
    };
  }
}
