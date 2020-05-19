import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/ui/colors.dart';

class OperationTile extends StatelessWidget {
  // Curent operation
  final Operation operation;

  // OnTap function
  final void Function() onTap;

  const OperationTile({Key key, @required this.operation, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0)
    ),
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
