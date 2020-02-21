import 'package:flutter/material.dart';
import 'package:treasurer/core/routes.dart';
import 'package:treasurer/core/services/locator.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: Router.generateRoute,
    );
  }
}
