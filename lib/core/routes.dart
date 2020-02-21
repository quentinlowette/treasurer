import 'package:flutter/material.dart';
import 'package:treasurer/ui/views/account.v.dart';

/// Navigation helper that generates the routes of the application
class Router {
  /// Generates the routes from given route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Switch on the route name
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => AccountView());
      default:
        // Default page return if the route name is unknown
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
