import 'package:flutter/material.dart';

/// Navigation Service
///
/// Allows to extract the navigation from the views, the UI and put it inside the logic, the viewModels.
class NavigationService {
  // Navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigates to the given [routeName]
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  /// Pops the current view
  ///
  /// If non-null, `result` will be used as the result of the route being popped.
  void goBack<T extends Object>([T result]) {
    return navigatorKey.currentState.pop<T>(result);
  }
}
