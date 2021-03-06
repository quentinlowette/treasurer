import 'package:flutter/material.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';

/// The header of the account view].
///
/// Displays the total amount as well as the bank and cash ones.
class AccountHeader extends StatelessWidget {
  /// The view model of the described account.
  final AccountViewModel model;

  const AccountHeader({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Total",
            style: Theme.of(context).accentTextTheme.headline5,
          ),
          Text(
            "${model.total.toStringAsFixed(2)} €",
            style: Theme.of(context).accentTextTheme.headline3,
          ),
          SizedBox(height: 16.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Compte",
                    style: Theme.of(context).accentTextTheme.headline6,
                  ),
                  Text(
                    "${model.bank.toStringAsFixed(2)} €",
                    style: Theme.of(context).accentTextTheme.headline5,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Caisse",
                    style: Theme.of(context).accentTextTheme.headline6,
                  ),
                  Text(
                    "${model.cash.toStringAsFixed(2)} €",
                    style: Theme.of(context).accentTextTheme.headline5,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
