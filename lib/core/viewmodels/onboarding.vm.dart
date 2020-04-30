import 'package:flutter/foundation.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';

class OnboardingViemModel extends ChangeNotifier {
  /// Bank amount encoded by the user
  double bankAmount = 0.0;

  /// Cash amount encoded by the user
  double cashAMount = 0.0;

  /// Instance of the navigation service
  NavigationService _navigationService = locator<NavigationService>();

  /// Exits the onboarding view
  void exit() {
    List<double> amounts = [bankAmount, cashAMount];
    _navigationService.goBack<List<double>>(amounts);
  }
}
