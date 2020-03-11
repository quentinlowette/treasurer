import 'package:flutter/material.dart';

/// Navigation Service
///
/// Allows to extract the navigation from the views, the UI and put it inside the logic, the viewModels.
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  bool goBack() {
    return navigatorKey.currentState.pop();
  }
}
