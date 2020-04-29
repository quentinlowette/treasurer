import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/viewmodels/operation.vm.dart';

/// View of an operation
///
/// Displays the operation's details
class OperationView extends StatelessWidget {
  final Operation operation;

  const OperationView({Key key, @required this.operation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OperationViewModel>.reactive(
      viewModelBuilder: () => OperationViewModel(operation: operation),
      builder: (context, model, _) => Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => model.exit(),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => model.deleteOperation(),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => model.editOperation(),
                    ),
                  ],
                ),
                Text(model.operation.description),
                Text("${model.operation.amount} €"),
                Text(DateFormat('dd/MM/yyyy').format(model.operation.date)),
                Text("From ${operation.src} To ${operation.dst}"),
                Text("${model.operation.receiptPhotoPath}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
