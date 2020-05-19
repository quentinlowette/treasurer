import 'package:flutter/material.dart';

/// A service of navigation.
///
/// Allows to extract the navigation from the views and
/// put it inside the viewModels.
class NavigationService {
  // Navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Navigates to the `routeName`.
  ///
  /// It will push the route associated with the given `routeName`
  /// onto the stack of routes.
  /// The provided `arguments` are passed to the pushed route
  /// via [RouteSettings.arguments].
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  /// Pops the current view.
  ///
  /// If non-null, `result` will be used as the result of the route
  /// that is popped; the future that had been returned from pushing
  /// the popped route will complete with `result`.
  void goBack<T extends Object>([T result]) {
    return navigatorKey.currentState.pop<T>(result);
  }
}
