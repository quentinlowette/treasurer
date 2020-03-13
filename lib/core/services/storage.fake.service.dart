import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// Fake implementation of the storage service
class FakeStorageService extends StorageService {
  @override
  Future<int> addOperation(Operation operation) {
    // do nothing
    return null;
  }

  @override
  Future<bool> deleteOperation(Operation operation) {
    // do nothing
    return null;
  }

  @override
  Future<List<Operation>> getOperations() async {
    Operation op1 = Operation(
        amount: 200.0,
        date: DateTime.utc(2020, 2, 20, 10, 00),
        description: "Fake operation 1",
        id: 1,
        isCash: false,
        receiptPhotoPath: null);
    Operation op2 = Operation(
        amount: -100.0,
        date: DateTime.utc(2020, 2, 20, 12, 00),
        description: "Fake operation 2",
        id: 2,
        isCash: false,
        receiptPhotoPath: null);
    Operation op3 = Operation(
        amount: 50.0,
        date: DateTime.utc(2020, 2, 21, 10, 00),
        description: "Fake operation 3",
        id: 3,
        isCash: true,
        receiptPhotoPath: null);
    Operation op4 = Operation(
        amount: 200.0,
        date: DateTime.utc(2020, 2, 21, 12, 00),
        description: "Fake operation 4",
        id: 4,
        isCash: false,
        receiptPhotoPath: null);
    Operation op5 = Operation(
        amount: -100.0,
        date: DateTime.utc(2020, 2, 21, 13, 00),
        description: "Fake operation 5",
        id: 5,
        isCash: false,
        receiptPhotoPath: null);
    Operation op6 = Operation(
        amount: 50.0,
        date: DateTime.utc(2020, 2, 21, 14, 00),
        description: "Fake operation 6",
        id: 6,
        isCash: true,
        receiptPhotoPath: null);
    Operation op7 = Operation(
        amount: -100.0,
        date: DateTime.utc(2020, 2, 21, 15, 00),
        description: "Fake operation 7",
        id: 7,
        isCash: false,
        receiptPhotoPath: null);
    Operation op8 = Operation(
        amount: 50.0,
        date: DateTime.utc(2020, 2, 21, 16, 00),
        description: "Fake operation 8",
        id: 8,
        isCash: true,
        receiptPhotoPath: null);
    List<Operation> operations = List<Operation>();
    operations.add(op1);
    operations.add(op2);
    operations.add(op3);
    operations.add(op4);
    operations.add(op5);
    operations.add(op6);
    operations.add(op7);
    operations.add(op8);

    await Future.delayed(Duration(seconds: 3), () => null);
    return operations;
  }

  @override
  Future<List<double>> getAmounts() async {
    List<double> amounts = List<double>();

    amounts.add(250.0);
    amounts.add(100.0);
    amounts.add(150.0);

    await Future.delayed(Duration(milliseconds: 500), () => null);
    return amounts;
  }

  @override
  Future<bool> updateOperation(Operation operation) {
    // do nothing
    return null;
  }
}
