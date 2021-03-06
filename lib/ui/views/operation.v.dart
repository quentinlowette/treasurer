import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/models/operation.m.dart';
import 'package:treasurer/core/viewmodels/operation.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/theme.dart';
import 'package:treasurer/ui/widgets/buttons.dart';
import 'package:treasurer/ui/widgets/image_button.dart';

/// View of an operation.
///
/// Displays the operation's details.
class OperationView extends StatelessWidget {
  /// The operation to detail.
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
                  ImageButton(
                    imagePath: model.operation.receiptPhotoPath,
                  )
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
                    "${model.operation.amount.toStringAsFixed(2)} €",
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
                      Text(
                        "${operation.source}",
                        style: Theme.of(context).accentTextTheme.headline6,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: DefaultThemeColors.white,
                      ),
                      Text(
                        "${operation.destination}",
                        style: Theme.of(context).accentTextTheme.headline6,
                      ),
                    ],
                  ),
                  Spacer(),
                  CustomRaisedButton(
                    backgroundColor: DefaultThemeColors.white,
                    textColor: DefaultThemeColors.blue,
                    title: "Modifier",
                    onPressed: () => model.editOperation(),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
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
