import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/widgets/operationDialog.dart';

class OperationTile extends StatelessWidget {
  final Operation operation;
  final AccountViewModel model;

  OperationTile({@required this.operation, @required this.model});

  @override
  Widget build(BuildContext context) => Dismissible(
        key: ValueKey(operation.id),
        confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text("Êtes-vous sûr de vouloir supprimer cette opération ?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Annuler",
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () => model.navigateBack(),
              ),
              FlatButton(
                child: Text(
                  "Supprimer",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
                onPressed: () {
                  model.removeOperation(operation);
                },
              ),
            ],
          ),
        ),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Theme.of(context).errorColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        child: ListTile(
          title: Text(
            operation.description,
            style: Theme.of(context).accentTextTheme.subtitle1,
          ),
          subtitle: Text(DateFormat("dd/MM/yyyy").format(operation.date),
              style: Theme.of(context).accentTextTheme.bodyText2),
          trailing: Text("${operation.amount}",
              style: Theme.of(context).accentTextTheme.subtitle2),
          onTap: () => showDialog(
              context: context, child: OperationDialog(operation: operation)),
        ),
      );
}
