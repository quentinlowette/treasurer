import 'package:flutter/foundation.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/router.dart';
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
    double amount = removed ? -1 * operation.amount : operation.amount;

    if (operation.dst == Actor.cash) {
      _cash += amount;
    }
    if (operation.src == Actor.cash) {
      _cash -= amount;
    }
    if (operation.dst == Actor.bank) {
      _bank += amount;
    }
    if (operation.src == Actor.bank) {
      _bank -= amount;
    }

    _total = _bank + _cash;

    _cash = double.parse(_cash.toStringAsFixed(2));
    _bank = double.parse(_bank.toStringAsFixed(2));
    _total = double.parse(_total.toStringAsFixed(2));
  }

  /// Navigates to the operation's editor and then adds the new operation
  Future<void> newOperation() async {
    Operation newOperation =
        await _navigationService.navigateTo(Router.OperationEditorViewRoute);

    // If an operation was returned by the operation's editor
    if (newOperation != null) {
      addOperation(newOperation);
    }
  }

  /// Navigates to the Operation view
  void navigateToOperation(Operation operation) {
    _navigationService.navigateTo(Router.OperationViewRoute,
        arguments: operation);
  }

  /// Loads the stored operations
  Future<void> loadData() async {
    // Fetches the operations from the storage service
    _operations = await _storageService.getOperations();

    List<double> amounts = await _storageService.getAmounts();

    _total = amounts[0];
    _bank = amounts[1];
    _cash = amounts[2];

    if (_operations.isEmpty) {
      List<double> amounts =
          await _navigationService.navigateTo(Router.OnboardingViewRoute);

      Operation _initBankAmount = Operation(
        amount: amounts[0],
        date: DateTime.now(),
        description: "Montant initial sur le compte",
        src: Actor.extern,
        dst: Actor.bank,
        receiptPhotoPath: null,
      );

      Operation _initCashAmount = Operation(
        amount: amounts[1],
        date: DateTime.now(),
        description: "Montant initial dans la caisse",
        src: Actor.extern,
        dst: Actor.cash,
        receiptPhotoPath: null,
      );

      await addOperation(_initBankAmount);
      await addOperation(_initCashAmount);
    }
    
    _isLoaded = true;

    // Notifies the changes
    notifyListeners();
  }

  /// Adds an operation
  Future<void> addOperation(Operation operation) async {
    // Adds the operation to the storage
    operation.id = await _storageService.addOperation(operation);

    // If the database's operation succeeds
    if (operation.id != null) {
      // Adds the operation to the loaded list
      _operations.add(operation);

      // Changes the amounts
      _updateAmounts(operation);

      // Notifies the changes
      notifyListeners();
    }
  }

  /// Removes an operation
  Future<void> removeOperation(Operation operation) async {
    // Removes the operation from the storage
    bool success = await _storageService.deleteOperation(operation);

    // If the database's operation succeeds
    if (success) {
      // Removes the operation from the loaded list
      _operations.remove(operation);

      // Changes the amounts
      _updateAmounts(operation, removed: true);

      // Notifies the changes
      notifyListeners();
    }
  }

  /// Updates an operation
  Future<void> updateOperation(
      Operation oldOperation, Operation newOperation) async {
    // Removes the operation from the storage
    bool success = await _storageService.updateOperation(newOperation);

    // If the database's operation succeeds
    if (success) {
      // Updates the operation from the loaded list
      _operations.remove(oldOperation);
      _operations.add(newOperation);

      // Changes the amounts
      _updateAmounts(oldOperation, removed: true);
      _updateAmounts(newOperation, removed: false);

      // Notifies the changes
      notifyListeners();
    }
  }
}
