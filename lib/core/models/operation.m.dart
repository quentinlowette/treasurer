import 'package:flutter/foundation.dart';
import 'package:treasurer/core/models/actor.m.dart';

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

  /// Source Actors of the operation
  final Actor src;

  /// Destination Actors of the operation
  final Actor dst;

  /// Path of the receipt photo associated to the operation
  final String receiptPhotoPath;

  Operation(
      {@required this.amount,
      @required this.date,
      @required this.description,
      @required this.src,
      @required this.dst,
      @required this.receiptPhotoPath,
      this.id});
}
