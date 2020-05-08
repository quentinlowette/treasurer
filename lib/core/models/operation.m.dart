import 'package:treasurer/core/models/actor.m.dart';

/// A model of an operation.
class Operation {
  /// The amount exchange in this operation.
  final double amount;

  /// The date of this operation
  final DateTime date;

  /// The description of this operation
  final String description;

  /// The id of this operation in the database
  int id;

  /// Source Actors of the operation
  final Actor source;

  /// Destination Actors of the operation
  final Actor destination;

  /// Path of the receipt photo associated to the operation
  final String receiptPhotoPath;

  Operation(this.amount, this.date, this.description, this.source,
      this.destination, this.receiptPhotoPath,
      [this.id]);
}
