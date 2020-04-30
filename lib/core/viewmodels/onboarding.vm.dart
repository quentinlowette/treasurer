import 'package:flutter/foundation.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';

class OnboardingViemModel extends ChangeNotifier {
  /// Instance of the navigation service
  NavigationService _navigationService = locator<NavigationService>();

  /// Exits the onboarding view
  void exit(double bankAmount, double cashAmount) {
    List<double> amounts = [bankAmount, cashAmount];
    _navigationService.goBack<List<double>>(amounts);
  }
}
