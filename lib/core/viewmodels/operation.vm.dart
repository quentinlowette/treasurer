import 'package:flutter/foundation.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/router.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';

/// View Model of the operation view
class OperationViewModel extends ChangeNotifier {
  /// Operation
  Operation operation;

  /// Instance of the navigation service
  NavigationService _navigationService = locator<NavigationService>();

  /// Account ViewModel
  AccountViewModel _accountViewModel = locator<AccountViewModel>();

  OperationViewModel({@required this.operation});

  /// Exits the operation view
  void exit() {
    _navigationService.goBack();
  }

  /// Opens the OperationEditor view and updates the operation
  Future<void> editOperation() async {
    // Opens edit view and wait for the new Operation
    Operation newOperation = await _navigationService
        .navigateTo(Router.OperationEditorViewRoute, arguments: operation);

    // Update the operation
    if (newOperation != null) {
      // Caals the account viewmodel to update the operation
      await _accountViewModel.updateOperation(operation, newOperation);

      // Updates current operation
      operation = newOperation;

      // Notifies changes
      notifyListeners();
    }
  }

  /// Deletes this operation
  Future<void> deleteOperation() async {
    await _accountViewModel.removeOperation(operation);

    exit();
  }
}
