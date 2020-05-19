import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

/// A titled and touchable field for the operation's editor.
class OperationEditorField extends StatelessWidget {
  /// The alignment to use.
  final CrossAxisAlignment alignment;

  /// The validation's flag.
  final bool isValid;

  /// The function to call when the field is tapped.
  final void Function() onTap;

  /// The subtitle of this field.
  final Widget subtitle;

  /// The title of this field.
  final String title;

  const OperationEditorField({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.isValid,
    @required this.alignment,
    @required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: DefaultThemeColors.white,
        child: Column(
          crossAxisAlignment: alignment,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: isValid ? DefaultThemeColors.blue : DefaultThemeColors.error,
              )
            ),
            subtitle,
          ],
        ),
      ),
    );
  }
}
