import 'package:flutter/material.dart';
import 'package:treasurer/core/models/operation.m.dart';

class OperationTile extends StatelessWidget {
  final Operation operation;

  OperationTile({@required this.operation});

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(operation.description),
    subtitle: Text("${operation.date.day.toString().padLeft(2, '0')}/${operation.date.month.toString().padLeft(2, '0')}/${operation.date.year}"),
    trailing: Text("${operation.amount} €"),
  );
}
