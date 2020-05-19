import 'package:flutter/foundation.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/router.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';

/// View Model of the Operation view.
class OperationViewModel extends ChangeNotifier {
  /// The underlying [Operation].
  Operation operation;

  /// An instance of the [NavigationService].
  NavigationService _navigationService = locator<NavigationService>();

  /// The global [AccountViewModel].
  AccountViewModel _accountViewModel = locator<AccountViewModel>();

  OperationViewModel({@required this.operation});

  /// Exits the operation view.
  void exit() {
    _navigationService.goBack();
  }

  /// Opens the OperationEditor view and updates the operation.
  Future<void> editOperation() async {
    // Opens the editor view and wait for the new Operation.
    Operation newOperation = await _navigationService
        .navigateTo(Router.OperationEditorViewRoute, arguments: operation);

    // If an operation is returned.
    if (newOperation != null) {
      // Calls the account view model to update the operation.
      await _accountViewModel.updateOperation(operation, newOperation);

      // Updates the underlying operation.
      operation = newOperation;

      // Notifies changes.
      notifyListeners();
    }
  }

  /// Deletes this operation.
  Future<void> deleteOperation() async {
    await _accountViewModel.removeOperation(operation);

    exit();
  }
}
