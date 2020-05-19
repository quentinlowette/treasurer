import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:treasurer/core/router.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/services/navigation.service.dart';
import 'package:treasurer/ui/theme.dart';

void main() {
  // Sets up the services provider
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Treasurer',
      theme: CustomTheme.defaultTheme,
      initialRoute: Router.InitialRoute,
      onGenerateRoute: Router.generateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr', 'BE')
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
