import 'package:flutter/material.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/services/chart.service.dart';
import 'package:treasurer/core/services/locator.dart';
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
  int _nextOperationIndex;

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

  /// Getter for the next operation's index
  int get nextOperationIndex => _nextOperationIndex;

  /// Instance of the storage service
  StorageService _storageService = locator<StorageService>();

  /// Instance of the chart service
  ChartService _chartService = locator<ChartService>();

  /// Loads the stored operations
  Future loadData() async {
    // Fetches the operations from the storage service
    _operations = await _storageService.getOperations();

    List<double> amounts = await _storageService.getAmounts();

    _total = amounts[0];
    _bank = amounts[1];
    _cash = amounts[2];

    _nextOperationIndex = _operations.last.id + 1;

    _isLoaded = true;

    // Notifies the changes
    notifyListeners();
  }

  /// Adds an operation to the list
  Future addOperation(Operation operation) async {
    // Adds the operation to the loaded list
    _operations.add(operation);

    // Adds the operation to the storage
    await _storageService.addOperation(operation);

    // Increases the next operation index
    _nextOperationIndex++;

    // Notifies the changes
    notifyListeners();
  }

  Widget getAmountsChart() {
    List<double> fractions = [_cash/_total, _bank/_total];
    return _chartService.getPieChart(fractions);
  }
}
