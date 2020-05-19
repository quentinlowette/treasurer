import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/ui/colors.dart';

/// A tile of the account view describing one [Operation].
class OperationTile extends StatelessWidget {
  /// The described [Operation].
  final Operation operation;

  /// The function to call when the tile is tapped.
  final void Function() onTap;

  const OperationTile({Key key, @required this.operation, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: DefaultThemeColors.white,
      child: ListTile(
        title: Text(
          operation.description,
        ),
        subtitle: Text(
          DateFormat("dd/MM/yyyy").format(operation.date),
        ),
        trailing: Text(
          "${operation.amount.toStringAsFixed(2)}",
        ),
        onTap: onTap,
      ),
    );
  }
}
