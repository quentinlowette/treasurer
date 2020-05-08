import 'package:treasurer/core/database/dao/dao.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';

/// The operation Data-Access Object.
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
  OperationDao() {
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
      src: Actor(ActorType.values[map[src]]),
      dst: Actor(ActorType.values[map[dst]]),
      receiptPhotoPath: map[receiptPhotoPath],
    );
  }

  @override
  Map<String, dynamic> toMap(Operation operation) {
    return {
      amount: operation.amount,
      date: operation.date.millisecondsSinceEpoch,
      description: operation.description,
      src: operation.src.toIndex(),
      dst: operation.dst.toIndex(),
      receiptPhotoPath: operation.receiptPhotoPath
    };
  }
}
