import 'package:flutter/foundation.dart';

/// Model of an Operation
class Operation {
  /// Amount exchange in the operation
  final double amount;

  /// Date of the operation
  final DateTime date;

  /// Description of the operation
  final String description;

  /// Id of the operation in the database
  int id;

  /// Boolean that is true if the operation is made on the cash and false if not
  final bool isCash;

  /// Path of the receipt photo associated to the operation
  final String receiptPhotoPath;

  Operation(
      {@required this.amount,
      @required this.date,
      @required this.description,
      @required this.isCash,
      @required this.receiptPhotoPath,
      this.id});
}
