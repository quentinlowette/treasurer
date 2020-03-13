import 'package:flutter/material.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/ui/views/account.v.dart';
import 'package:treasurer/ui/views/operationEditor.v.dart';
import 'package:treasurer/ui/views/operation.v.dart';

/// Navigation helper that generates the routes of the application
class Router {
  /// Initial route
  static const String InitialRoute = '/';

  // Route's definitions
  /// Route of the Account View
  static const String AccountViewRoute = '/';

  /// Route of the Operation Editor View
  ///
  /// Navigation has one optional parameter of type `Operation`
  ///
  /// Navigation returns an `Operation` or `null`
  static const String OperationEditorViewRoute = '/operationEditor';

  /// Route of the Operation View
  ///
  /// Navigation has one optional parameter of type `Operation`
  static const String OperationViewRoute = '/operation';

  /// Generates the routes from given route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Switch on the route name
    switch (settings.name) {
      case AccountViewRoute:
        return MaterialPageRoute(builder: (_) => AccountView());
      case OperationEditorViewRoute:
        // Cast arguments
        Operation operation = settings.arguments as Operation;
        return MaterialPageRoute(
            builder: (_) => OperationEditorView(
                  initialOperation: operation,
                ));
      case OperationViewRoute:
        // Cast arguments
        Operation operation = settings.arguments as Operation;
        return MaterialPageRoute(
            builder: (_) => OperationView(
                  operation: operation,
                ));
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
