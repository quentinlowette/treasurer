import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

class CustomRaisedButton extends StatelessWidget {
  final void Function() onPressed;

  final String title;

  CustomRaisedButton({this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: EdgeInsets.symmetric(vertical: 16.0),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 16.0),
        ));
  }
}

class CustomGradientRaisedButton extends StatelessWidget {
  final void Function() onPressed;

  final String title;

  CustomGradientRaisedButton({this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: EdgeInsets.symmetric(vertical: 16.0),
        onPressed: onPressed,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.7, 0.9],
                colors: [
                  DefaultThemeColors.blue1,
                  DefaultThemeColors.blue2,
                  DefaultThemeColors.blue3,
                  DefaultThemeColors.blue4,
                ],
              ),
            ),
            child: Text(
              title,
              style: TextStyle(fontSize: 16.0),
            )));
  }
}
