import 'package:treasurer/core/models/operation.m.dart';

/// Storage Service
abstract class StorageService {
  /// Adds an operation to the storage.
  ///
  /// Returns the id of the inserted operation
  Future<int> addOperation(Operation operation);

  /// Deletes the given operation from storage
  Future<void> deleteOperation(Operation operation);

  /// Returns the stored list of operations
  Future<List<Operation>> getOperations();

  /// Returns the total, cash and bank amounts based on the operations
  Future<List<double>> getAmounts();

  /// Updates the given operation in storage
  Future<void> updateOperation(Operation operation);
}
