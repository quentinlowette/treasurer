import 'package:treasurer/core/models/operation.m.dart';

export 'storage.database.service.dart';

/// An abstract storage service
abstract class StorageService {
  /// Adds an operation to the storage.
  ///
  /// Returns the id of the inserted operation.
  Future<int> addOperation(Operation operation);

  /// Deletes the given [operation] from the storage.
  ///
  /// Returns `true` if the deletion succeeds.
  Future<bool> deleteOperation(Operation operation);

  /// Returns the list of operations.
  Future<List<Operation>> getOperations();

  /// Returns the total, cash and bank amounts.
  ///
  /// Computes the bank and cash amounts given the stored operatins and
  /// adds them to obtain the total.
  Future<List<double>> getAmounts();

  /// Updates the given [operation] in the storage.
  ///
  /// Returns `true` if the update succeeds.
  Future<bool> updateOperation(Operation operation);
}
