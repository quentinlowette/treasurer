import 'package:flutter/foundation.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// Model of an Operation
class Operation {
  final double amount;
  final DateTime date;
  final String description;
  final int id;
  final bool isCash;
  final String receiptPhotoPath;

  Operation({
    @required this.amount,
    @required this.date,
    @required this.description,
    @required this.id,
    @required this.isCash,
    @required this.receiptPhotoPath
  });

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
