import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/viewmodels/operation.vm.dart';

/// View of an operation
///
/// Displays the operation's details
class OperationView extends StatelessWidget {
  final Operation operation;

  OperationView({@required this.operation});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<OperationViewModel>.withConsumer(
      viewModel: OperationViewModel(operation: operation),
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
                      icon: Icon(Icons.edit),
                      onPressed: () => model.editOperation(),
                    ),
                  ],
                ),
                Text(operation.description),
                Text("${operation.amount} €"),
                Text(DateFormat('dd/MM/yyyy').format(operation.date)),
                Text("${operation.isCash}"),
                Text("${operation.receiptPhotoPath}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
