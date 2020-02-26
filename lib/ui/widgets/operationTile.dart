import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/ui/widgets/operationDialog.dart';

class OperationTile extends StatelessWidget {
  final Operation operation;

  OperationTile({@required this.operation});

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(operation.description, style: Theme.of(context).accentTextTheme.subtitle1,),
    subtitle: Text(DateFormat("dd/MM/yyyy").format(operation.date), style: Theme.of(context).accentTextTheme.bodyText2),
    trailing: Text("${operation.amount}", style: Theme.of(context).accentTextTheme.subtitle2),
    onTap: () => showDialog(
        context: context, child: OperationDialog(operation: operation)),
  );
}
