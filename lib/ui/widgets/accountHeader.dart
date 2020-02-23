import 'package:flutter/material.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';

class AccountHeader extends StatelessWidget {
  final AccountViewModel model;

  AccountHeader({@required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Total", style: Theme.of(context).accentTextTheme.headline4,),
          Text("${model.total} €", style: Theme.of(context).accentTextTheme.headline3,),
          SizedBox(height: 60.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Cash", style: Theme.of(context).accentTextTheme.headline6,),
                  Text("${model.cash} €", style: Theme.of(context).accentTextTheme.headline5,),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("Bank", style: Theme.of(context).accentTextTheme.headline6,),
                  Text("${model.bank} €", style: Theme.of(context).accentTextTheme.headline5,),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
