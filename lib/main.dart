import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:treasurer/core/routes.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/ui/theme.dart';

void main() {
  // setting up the services provider
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.defaultTheme,
      initialRoute: '/',
      onGenerateRoute: Router.generateRoute,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr')
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
