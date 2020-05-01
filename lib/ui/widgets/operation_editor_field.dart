import 'package:flutter/material.dart';
import 'package:treasurer/ui/colors.dart';

class OperationEditorField extends StatelessWidget {
  final String title;
  final Widget subtitle;
  final bool isValid;
  final CrossAxisAlignment alignment;
  final void Function() onTap;

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
