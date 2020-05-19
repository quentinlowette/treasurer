import 'package:flutter/material.dart';

/// A custom raised button.
///
/// Wraps the standard [RaisedButton] with specific paramters.
class CustomRaisedButton extends StatelessWidget {
  /// The background color.
  final Color backgroundColor;

  /// The function to call when the buutton is pressed.
  final void Function() onPressed;

  /// The color of this button's text.
  final Color textColor;

  /// The text of this button.
  final String title;

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

/// A custom outline button.
///
/// Wraps the standard [OutlineButton] with specific paramters.
class CustomOutlineButton extends StatelessWidget {
  /// The function to call when the buutton is pressed.
  final void Function() onPressed;

  /// The color of the border.
  final Color outlineColor;

  /// The color of this button's text.
  final Color textColor;

  /// The text of this button.
  final String title;

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
