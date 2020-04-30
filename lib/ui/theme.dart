import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

class CustomTheme {
  static final ThemeData defaultTheme = _buildDefaultTheme();

  static TextTheme _buildDefaultTextTheme() {
    TextTheme base = ThemeData.light().textTheme;

    return base.copyWith(
      headline3: base.headline3.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w700,
      ),
      headline4: base.headline4.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
      headline5: base.headline5.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w700,
      ),
      headline6: base.headline6.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
      subtitle1: base.subtitle1.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
      subtitle2: base.subtitle2.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w400,
      ),
      bodyText1: base.bodyText1.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
      bodyText2: base.bodyText2.copyWith(
        color: DefaultThemeColors.black,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w400,
      )
    );
  }

  static TextTheme _buildAccentTextTheme() {
    TextTheme base = ThemeData.light().accentTextTheme;

    return base.copyWith(
      headline3: base.headline3.copyWith(
        color: DefaultThemeColors.white,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w700,
      ),
      headline4: base.headline4.copyWith(
        color: DefaultThemeColors.white,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
      headline5: base.headline5.copyWith(
        color: DefaultThemeColors.white,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w700,
      ),
      headline6: base.headline6.copyWith(
        color: DefaultThemeColors.white,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
      subtitle1: base.subtitle1.copyWith(
        color: DefaultThemeColors.white,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
      subtitle2: base.subtitle2.copyWith(
        color: DefaultThemeColors.white,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w400,
      ),
      bodyText1: base.bodyText1.copyWith(
        color: DefaultThemeColors.white,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w600,
      ),
      bodyText2: base.bodyText2.copyWith(
        color: DefaultThemeColors.white,
        fontFamily: 'Open Sans',
        fontWeight: FontWeight.w400,
      )
    );
  }

  static IconThemeData _buildDefaultIconTheme() {
    IconThemeData base = ThemeData.light().iconTheme;

    return base.copyWith(
      color: DefaultThemeColors.blue
    );
  }

  static ThemeData _buildDefaultTheme() {
    ThemeData base = ThemeData.light();

    return base.copyWith(
      primaryColor: DefaultThemeColors.blue,
      accentColor: DefaultThemeColors.blue,

      scaffoldBackgroundColor: DefaultThemeColors.white,

      textTheme: _buildDefaultTextTheme(),
      accentTextTheme: _buildAccentTextTheme(),

      iconTheme: _buildDefaultIconTheme(),
    );
  }
}
