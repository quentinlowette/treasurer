import 'package:treasurer/core/database/dao/dao.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';

/// The operation Data-Access Object.
class OperationDao extends Dao<Operation> {
  // Columns names
  final String id = "id";
  final String amount = "amount";
  final String source = "source";
  final String destination = "destination";
  final String date = "date";
  final String description = "description";
  final String receiptPhotoPath = "receiptPhotoPath";

  // Constructor
  OperationDao() {
    // Columns definition
    columnsDefinition = [
      [id, "INTEGER PRIMARY KEY AUTOINCREMENT"],
      [amount, "REAL NOT NULL"],
      [source, "INTEGER NOT NULL"],
      [destination, "INTEGER NOT NULL"],
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
      map[amount],
      DateTime.fromMillisecondsSinceEpoch(map[date]),
      map[description],
      Actor(ActorType.values[map[source]]),
      Actor(ActorType.values[map[destination]]),
      map[receiptPhotoPath],
      map[id],
    );
  }

  @override
  Map<String, dynamic> toMap(Operation operation) {
    return {
      amount: operation.amount,
      date: operation.date.millisecondsSinceEpoch,
      description: operation.description,
      source: operation.source.toInteger(),
      destination: operation.destination.toInteger(),
      receiptPhotoPath: operation.receiptPhotoPath
    };
  }
}
