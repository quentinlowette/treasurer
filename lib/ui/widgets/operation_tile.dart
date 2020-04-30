import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treasurer/core/models/operation.m.dart';

class OperationTile extends StatelessWidget {
  // Curent operation
  final Operation operation;

  // OnTap function
  final void Function() onTap;

  const OperationTile({Key key, @required this.operation, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(
      operation.description,
      style: Theme.of(context).accentTextTheme.subtitle1,
    ),
    subtitle: Text(DateFormat("dd/MM/yyyy").format(operation.date),
        style: Theme.of(context).accentTextTheme.bodyText2),
    trailing: Text("${operation.amount}",
        style: Theme.of(context).accentTextTheme.subtitle2),
    onTap: onTap,
  );
}
