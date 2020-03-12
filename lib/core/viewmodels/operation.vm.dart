import 'package:flutter/foundation.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/router.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';

/// View Model of the operation view
class OperationViewModel extends ChangeNotifier {
  /// Operation
  Operation operation;

  /// Instance of the navigation service
  NavigationService _navigationService = locator<NavigationService>();

  /// Constructor
  OperationViewModel({@required this.operation});

  /// Exits the operation view
  void exit() {
    _navigationService.goBack();
  }

  /// Opens the edit view and updates the operation
  Future<void> editOperation() async{
    /// Opens edit view and wait for the new Operation
    operation = await _navigationService.navigateTo(Router.AddOperationViewRoute, arguments: operation);

    /// Notifies changes
    notifyListeners();
  }
}
