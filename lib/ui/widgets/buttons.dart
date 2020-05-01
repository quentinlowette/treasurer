import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final void Function() onPressed;

  final String title;

  final Color backgroundColor;

  final Color textColor;

  CustomRaisedButton({
    this.onPressed,
    this.title,
    this.backgroundColor,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.symmetric(vertical: 16.0),
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1.copyWith(color: textColor),
      ));
  }
}

class CustomOutlineButton extends StatelessWidget {
  final void Function() onPressed;

  final String title;

  final Color outlineColor;

  final Color textColor;

  CustomOutlineButton({
    this.onPressed,
    this.title,
    this.outlineColor,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(color: outlineColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.symmetric(vertical: 16.0),
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1.copyWith(color: textColor),
      )
    );
  }
}
