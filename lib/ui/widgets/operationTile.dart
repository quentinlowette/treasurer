import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/ui/widgets/operationDialog.dart';

class OperationTile extends StatelessWidget {
  final Operation operation;

  OperationTile({@required this.operation});

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(operation.description),
    subtitle: Text(DateFormat("dd/MM/yyyy").format(operation.date)),
    trailing: Text("${operation.amount} €"),
    onTap: () => showDialog(
      context: context,
      child: OperationDialog(operation: operation)
    ),
  );
}
