import 'package:flutter/material.dart';
import 'package:treasurer/core/models/operation.m.dart';

class OperationDialog extends StatelessWidget {
  final Operation operation;

  OperationDialog({@required this.operation});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${operation.description}", style: Theme.of(context).textTheme.headline5,),
            SizedBox(height: 10.0,),
            Text("${operation.date}"),
            Text("${operation.amount}"),
            Text("${operation.isCash}"),
            Text("${operation.receiptPhotoPath}"),
          ],
        ),
      ),
    );
  }
}
