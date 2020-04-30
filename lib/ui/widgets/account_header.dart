import 'package:flutter/material.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/widgets/charts/charts.dart';

class AccountHeader extends StatelessWidget {
  final AccountViewModel model;

  const AccountHeader({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
      child: Column(
        children: <Widget>[
          Chart(
            painter: PieChartPainter(
                fractions: [model.cash / model.total, model.bank / model.total],
                radius: 120.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Total",
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  "${model.total} €",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Bank",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: DefaultThemeColors.orangeLL),
                  ),
                  Text(
                    "${model.bank} €",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Cash",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: DefaultThemeColors.blueLL),
                  ),
                  Text(
                    "${model.cash} €",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30.0)
        ],
      ),
    );
  }
}
