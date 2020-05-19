import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:treasurer/core/models/actor.m.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/router.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/core/services/storage.service.dart';

/// View Model of the Account View.
class AccountViewModel extends ChangeNotifier {
  /// The loading status.
  bool _isLoading = true;

  /// The list of [Operation] done on this account.
  List<Operation> _operations;

  /// The total amount.
  double _total;

  /// The amount of cash.
  double _cash;

  /// The amount of money in the bank.
  double _bank;

  /// An instance of the [NavigationService].
  NavigationService _navigationService = locator<NavigationService>();

  /// An instance of the [StorageService].
  StorageService _storageService = locator<StorageService>();

  /// The getter for the loading status.
  bool get isLoading => _isLoading;

  /// The getter for the list of [Operation].
  List<Operation> get operations => _operations;

  /// The getter for the total amount.
  double get total => _total;

  /// The getter for the cash amount.
  double get cash => _cash;

  /// The getter for the bank amount.
  double get bank => _bank;

  /// Updates the amounts.
  void _updateAmounts(Operation operation, {removed = false}) {
    double amount = removed ? -1 * operation.amount : operation.amount;

    if (operation.destination.hasType(ActorType.cash)) {
      _cash += amount;
    }
    if (operation.source.hasType(ActorType.cash)) {
      _cash -= amount;
    }
    if (operation.destination.hasType(ActorType.bank)) {
      _bank += amount;
    }
    if (operation.source.hasType(ActorType.bank)) {
      _bank -= amount;
    }

    _total = _bank + _cash;

    // TODO Sort this out
    // _cash = double.parse(_cash.toStringAsFixed(2));
    // _bank = double.parse(_bank.toStringAsFixed(2));
    // _total = double.parse(_total.toStringAsFixed(2));
  }

  /// Navigates to the operation's editor and then adds the returned operation.
  Future<void> newOperation() async {
    Operation newOperation =
        await _navigationService.navigateTo(Router.OperationEditorViewRoute);

    // If an operation was returned by the operation's editor
    if (newOperation != null) {
      addOperation(newOperation);
    }
  }

  /// Navigates to the Operation view.
  void navigateToOperation(Operation operation) {
    _navigationService.navigateTo(Router.OperationViewRoute,
        arguments: operation);
  }

  /// Navigates to the onboarding screens and
  /// sets up the account with the returned amounts.
  Future<void> _initAccount() async {
    List<double> amounts =
        await _navigationService.navigateTo(Router.OnboardingViewRoute);

    // Creates the initial bank amount.
    Operation _initBankAmount = Operation(
        amounts[0],
        DateTime.now(),
        "Montant initial sur le compte",
        Actor(ActorType.extern),
        Actor(ActorType.bank),
        null);

    // Creates the initial cash amount.
    Operation _initCashAmount = Operation(
        amounts[1],
        DateTime.now(),
        "Montant initial dans la caisse",
        Actor(ActorType.extern),
        Actor(ActorType.cash),
        null);

    // Adds the two created operations.
    await addOperation(_initBankAmount);
    await addOperation(_initCashAmount);
  }

  /// Loads the stored operations.
  Future<void> loadData() async {
    // Fetches the operations from the storage service.
    _operations = await _storageService.getOperations();

    // TODO Does this operation need to be performed on the DB or on the list of oerations fetched before ?
    // Fetches the amounts based on the stored operations.
    List<double> amounts = await _storageService.getAmounts();

    _total = amounts[0];
    _bank = amounts[1];
    _cash = amounts[2];

    // If there is no operation stored.
    if (_operations.isEmpty) {
      await _initAccount();
    }

    _isLoading = false;

    // Notifies the changes.
    notifyListeners();
  }

  /// Adds an [Operation].
  ///
  /// The given operation is added to the storage and to the list. The amounts
  /// are updated and the list is sorted.
  Future<void> addOperation(Operation operation) async {
    // Adds the operation to the storage.
    operation.id = await _storageService.addOperation(operation);

    // If the database's operation succeeds.
    if (operation.id != null) {
      // Adds the operation to the loaded list.
      _operations.add(operation);

      // Sorts the list.
      _operations.sort((a, b) => -(a.date.compareTo(b.date)));

      // Updates the amounts.
      _updateAmounts(operation);

      // Notifies the changes.
      notifyListeners();
    }
  }

  /// Removes an [Operation].
  ///
  /// The given operation is removed from the storage and the loaded list. The
  /// amounts are updated.
  Future<void> removeOperation(Operation operation) async {
    // Removes the operation from the storage.
    bool success = await _storageService.deleteOperation(operation);

    // If the database's operation succeeds.
    if (success) {
      // Deletes the image file
      if (operation.receiptPhotoPath != null) {
        File file = File(operation.receiptPhotoPath);
        file.delete();
      }

      // Removes the operation from the loaded list.
      _operations.remove(operation);

      // Updates the amounts.
      _updateAmounts(operation, removed: true);

      // If, after removing the operation, the account doesn't have
      // any operation left, navigates to the onboarding screens.
      if (_operations.isEmpty) {
        await _initAccount();
      }

      // Notifies the changes.
      notifyListeners();
    }
  }

  /// Updates an [Operation].
  ///
  /// The given operation is updated in the storage and in the loaded list.
  /// The amounts are updated and the list is sorted.
  Future<void> updateOperation(
      Operation oldOperation, Operation newOperation) async {
    // Updates the operation in the storage.
    bool success = await _storageService.updateOperation(newOperation);

    // If the database's operation succeeds.
    if (success) {
      // Updates the operation in the loaded list.
      _operations.remove(oldOperation);
      _operations.add(newOperation);

      // Sorts the list.
      _operations.sort((a, b) => -(a.date.compareTo(b.date)));

      // Updates the amounts.
      _updateAmounts(oldOperation, removed: true);
      _updateAmounts(newOperation, removed: false);

      // Notifies the changes.
      notifyListeners();
    }
  }
}
