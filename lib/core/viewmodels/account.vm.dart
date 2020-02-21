import 'package:flutter/foundation.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// View Model of the Account View
class AccountViewModel extends ChangeNotifier {
  /// List of the operations done in this account
  List<Operation> _operations;

  /// Getter for the list of operations
  List<Operation> get operations => _operations;

  /// Instance of the storage service
  StorageService _storageService = locator<StorageService>();

  /// Loads the stored operations
  Future loadData() async {
    // Fetches the operations from the storage service
    _operations = await _storageService.getOperations();

    // Notify the changes
    notifyListeners();
  }
}
