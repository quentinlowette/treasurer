import 'package:flutter/foundation.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// Model of an Operation
class Operation {
  /// Amount exchange in the operation
  final double amount;

  /// Date of the operation
  final DateTime date;

  /// Description of the operation
  final String description;

  /// Id of the operation in the database
  final int id;

  /// Boolean that is true if the operation is made on the cash and false if not
  final bool isCash;

  /// Path of the receipt photo associated to the operation
  final String receiptPhotoPath;

  Operation(
      {@required this.amount,
      @required this.date,
      @required this.description,
      @required this.id,
      @required this.isCash,
      @required this.receiptPhotoPath});

  /// Convert this to a map corresponding to the database model
  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.otColumnAmount: this.amount,
      DatabaseHelper.otColumnDate: this.date,
      DatabaseHelper.otColumnDescription: this.description,
      DatabaseHelper.otColumnId: this.id,
      DatabaseHelper.otColumnIsCash: this.isCash,
      DatabaseHelper.otColumnReceiptPhotoPath: this.receiptPhotoPath
    };
  }
}
