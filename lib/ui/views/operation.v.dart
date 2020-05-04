import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/viewmodels/operation.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/theme.dart';
import 'package:treasurer/ui/widgets/buttons.dart';

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
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: CustomTheme.gradient,
              ),
            ),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: DefaultThemeColors.white,
                    onPressed: () => model.exit(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 80.0,
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    model.operation.description,
                    style: Theme.of(context).accentTextTheme.headline5,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "${model.operation.amount} €",
                    style: Theme.of(context).accentTextTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    DateFormat("dd/MM/yyyy").format(model.operation.date),
                    style: Theme.of(context).accentTextTheme.subtitle1,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "De",
                            style: Theme.of(context).accentTextTheme.subtitle1,
                          ),
                          Text(
                            "${operation.src}",
                            style: Theme.of(context).accentTextTheme.headline6,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "À",
                            style: Theme.of(context).accentTextTheme.subtitle1,
                          ),
                          Text(
                            "${operation.dst}",
                            style: Theme.of(context).accentTextTheme.headline6,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    model.operation.receiptPhotoPath ?? "Pas de photo",
                    style: Theme.of(context).accentTextTheme.headline6,
                  ),
                  Spacer(),
                  CustomRaisedButton(
                    backgroundColor: DefaultThemeColors.white,
                    textColor: DefaultThemeColors.blue,
                    title: "Modifier",
                    onPressed: () => model.editOperation(),
                  ),
                  SizedBox(height: 16.0,),
                  CustomRaisedButton(
                    backgroundColor: DefaultThemeColors.white,
                    textColor: DefaultThemeColors.error,
                    title: "Supprimer",
                    onPressed: () => model.deleteOperation(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
