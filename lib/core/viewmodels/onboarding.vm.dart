import 'package:flutter/foundation.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';

/// View Model of the Onboarding View.
class OnboardingViemModel extends ChangeNotifier {
  /// An instance of the [NavigationService].
  NavigationService _navigationService = locator<NavigationService>();

  /// Exits the onboarding view.
  ///
  /// Passes the given amounts as the result of the route being popped.
  void exit(double bankAmount, double cashAmount) {
    List<double> amounts = [bankAmount, cashAmount];
    _navigationService.goBack<List<double>>(amounts);
  }
}
