/// Model of an Operation
class Operation {
  final double amount;
  final DateTime date;
  final String description;
  final bool isCash;
  final String receiptPhotoPath;

  Operation({
    this.amount,
    this.date,
    this.description,
    this.isCash,
    this.receiptPhotoPath
  });
}
