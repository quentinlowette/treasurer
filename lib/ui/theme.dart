import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

class CustomTheme {
  static final ThemeData defaultTheme = _buildDefaultTheme();

  static _buildDefaultTextTheme() {
    TextTheme base = ThemeData.light().textTheme;

    return base.copyWith(
      headline2: base.headline2.copyWith(
        color: DefaultThemeColors.blue,
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.w300,
        fontSize: 60.0
      ),
      headline3: base.headline3.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Eczar',
        fontWeight: FontWeight.w700,
        fontSize: 48.0
      ),
      headline4: base.headline4.copyWith(
        color: DefaultThemeColors.blackLLL,
        fontWeight: FontWeight.w400,
        fontFamily: 'RobotoCondensed',
        fontSize: 28.0
      ),
      headline5: base.headline5.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Eczar',
        fontWeight: FontWeight.w700,
        fontSize: 24.0
      ),
      headline6: base.headline6.copyWith(
        color: DefaultThemeColors.blackLLL,
        fontWeight: FontWeight.w500,
        fontFamily: 'RobotoCondensed',
        fontSize: 20.0
      ),
    );
  }

  static _buildAccentTextTheme() {
    TextTheme base = ThemeData.light().accentTextTheme;

    return base.copyWith(
      headline6: base.headline6.copyWith(
        fontWeight: FontWeight.w500,
        fontFamily: 'RobotoCondensed',
        fontSize: 20.0
      ),
      subtitle1: base.subtitle1.copyWith(
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.w400,
        fontSize: 16.0
      ),
      subtitle2: base.subtitle1.copyWith(
        fontFamily: 'Eczar',
        fontWeight: FontWeight.w500,
        fontSize: 16.0
      ),
      bodyText1: base.subtitle1.copyWith(
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.w400,
        fontSize: 16.0
      ),
      bodyText2: base.subtitle1.copyWith(
        fontFamily: 'RobotoCondensed',
        fontWeight: FontWeight.w300,
        fontSize: 14.0
      )
    );
  }

  static _buildDefaultIconTheme() {
    IconThemeData base = ThemeData.light().iconTheme;

    return base.copyWith(
      color: DefaultThemeColors.blue,
      size: 32.0,
    );
  }

  static _buildDefaultTheme() {
    ThemeData base = ThemeData.light();

    return base.copyWith(
      primaryColor: DefaultThemeColors.blue,
      accentColor: DefaultThemeColors.blue,

      scaffoldBackgroundColor: DefaultThemeColors.white,

      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0.0,
        color: DefaultThemeColors.white,
        iconTheme: _buildDefaultIconTheme(),
        actionsIconTheme: _buildDefaultIconTheme()
      ),

      textTheme: _buildDefaultTextTheme(),
      accentTextTheme: _buildAccentTextTheme(),
    );
  }
}
