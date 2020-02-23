import 'package:flutter/material.dart';
import 'package:treasurer/core/models/operation.m.dart';

class OperationTile extends StatelessWidget {
  final Operation operation;

  OperationTile({@required this.operation});

  @override
  // Widget build(BuildContext context) => Card(
  //   margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
  //   child: Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Text(operation.description, style: Theme.of(context).textTheme.subtitle1,),
  //             Text("${operation.date.day.toString().padLeft(2, '0')}/${operation.date.month.toString().padLeft(2, '0')}/${operation.date.year}", style: Theme.of(context).textTheme.subtitle2,),
  //           ],
  //         ),
  //         Text("${operation.amount} €"),
  //       ],
  //     ),
  //   ),
  // );
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(operation.description),
    subtitle: Text("${operation.date.day.toString().padLeft(2, '0')}/${operation.date.month.toString().padLeft(2, '0')}/${operation.date.year}"),
    trailing: Text("${operation.amount} €"),
  );
}
