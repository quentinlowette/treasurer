import 'package:flutter/material.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// View Model of the Account View
class AccountViewModel extends ChangeNotifier {
  /// Loading status
  bool _isLoaded = false;

  /// List of the operations done in this account
  List<Operation> _operations;

  /// Total amount of the account
  double _total;

  /// Amount of cash of the account
  double _cash;

  /// Amount of bank of the account
  double _bank;

  /// Index of the next operation to insert
  // int _nextOperationIndex;

  /// Instance of the navigation service
  NavigationService _navigationService = locator<NavigationService>();

  /// Instance of the storage service
  StorageService _storageService = locator<StorageService>();

  /// Getter for the loading status
  bool get isLoaded => _isLoaded;

  /// Getter for the list of operations
  List<Operation> get operations => _operations;

  /// Getter for the total amount
  double get total => _total;

  /// Getter for the cash amount
  double get cash => _cash;

  /// Getter for the bank amount
  double get bank => _bank;

  /// Updates the amounts
  void _updateAmounts(Operation operation, {removed = false}) {
    if (removed) {
      if (operation.isCash) {
        _cash -= operation.amount;
      } else {
        _bank -= operation.amount;
      }
      _total -= operation.amount;
    } else {
      if (operation.isCash) {
        _cash += operation.amount;
      } else {
        _bank += operation.amount;
      }
      _total += operation.amount;
    }
    _cash = double.parse(_cash.toStringAsFixed(2));
    _bank = double.parse(_bank.toStringAsFixed(2));
    _total = double.parse(_total.toStringAsFixed(2));
  }

  /// Navigates to the AddOperation view
  void navigateToAddOperation() {
    _navigationService.navigateTo('/addOperation');
  }

  /// Navigates back to the previous view
  void navigateBack() {
    _navigationService.goBack();
  }

  /// Loads the stored operations
  Future loadData() async {
    // Fetches the operations from the storage service
    _operations = await _storageService.getOperations();

    List<double> amounts = await _storageService.getAmounts();

    _total = amounts[0];
    _bank = amounts[1];
    _cash = amounts[2];

    _isLoaded = true;

    // Notifies the changes
    notifyListeners();
  }

  /// Adds an operation to the list
  Future addOperation(Operation operation) async {
    // Adds the operation to the storage
    operation.id = await _storageService.addOperation(operation);

    // Adds the operation to the loaded list
    _operations.add(operation);

    // Changes the amounts
    _updateAmounts(operation);

    // Notifies the changes
    notifyListeners();
  }

  /// Removes an operation from the list
  Future removeOperation(Operation operation) async {
    // Removes the operation from the loaded list
    _operations.remove(operation);

    // Changes the amounts
    _updateAmounts(operation, removed: true);

    // Removes the operation from the storage
    await _storageService.deleteOperation(operation);

    // Notifies the changes
    notifyListeners();
    navigateBack();
  }
}
