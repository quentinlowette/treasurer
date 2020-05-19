import 'package:flutter/material.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/ui/views/account.v.dart';
import 'package:treasurer/ui/views/onboarding.v.dart';
import 'package:treasurer/ui/views/operation_editor.v.dart';
import 'package:treasurer/ui/views/operation.v.dart';

/// Navigation helper that generates the routes of the application.
class Router {
  /// The initial route.
  static const String InitialRoute = '/';

  /// The route of the [AccountView].
  static const String AccountViewRoute = '/';

  /// The route of the [OperationEditorView].
  ///
  /// Navigation has one optional parameter of type [Operation].
  ///
  /// Navigation returns an [Operation] or `null`.
  static const String OperationEditorViewRoute = '/operationEditor';

  /// The route of the [OperationView].
  ///
  /// Navigation has one optional parameter of type [Operation].
  static const String OperationViewRoute = '/operation';

  /// The route of the [OnboardingView].
  ///
  /// Navigation returns a [List<double>].
  static const String OnboardingViewRoute = '/onboarding';

  /// Generates the routes from the given route settings.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Switch on the route name.
    switch (settings.name) {
      case AccountViewRoute:
        return MaterialPageRoute(builder: (_) => AccountView());
      case OperationEditorViewRoute:
        // Casts arguments.
        Operation operation = settings.arguments as Operation;
        return MaterialPageRoute(
            builder: (_) => OperationEditorView(
                  initialOperation: operation,
                ));
      case OperationViewRoute:
        // Casts arguments.
        Operation operation = settings.arguments as Operation;
        return MaterialPageRoute(
            builder: (_) => OperationView(
                  operation: operation,
                ));
      case OnboardingViewRoute:
        return MaterialPageRoute(builder: (_) => OnboardingView());
      default:
        // Default page returned if the route name is unknown.
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
