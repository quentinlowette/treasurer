import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/widgets/account_header.dart';
import 'package:treasurer/ui/widgets/header_clipper.dart';
import 'package:treasurer/ui/widgets/operation_tile.dart';

/// View of an account
class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<AccountViewModel>.reactive(
          viewModelBuilder: () => locator<AccountViewModel>(),
          disposeViewModel: false,
          onModelReady: (model) => model.loadData(),
          builder: (context, model, child) {
            return Scaffold(
              body: !model.isLoaded
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ))
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Stack(children: <Widget>[
                        ClipPath(
                          clipper: HeaderClipper(),
                          child: Container(
                            height: 400.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.1, 0.4, 0.7, 0.9],
                                colors: [
                                  DefaultThemeColors.blue1,
                                  DefaultThemeColors.blue2,
                                  DefaultThemeColors.blue3,
                                  DefaultThemeColors.blue4,
                                ],
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    color: DefaultThemeColors.white,
                                    onPressed: () => model.newOperation(),
                                  ),
                                ],
                              ),
                              AccountHeader(
                                model: model,
                              ),
                              SizedBox(
                                height: 48.0,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: model.operations.length,
                                itemBuilder: (context, index) => OperationTile(
                                  operation: model.operations[index],
                                  onTap: () => model.navigateToOperation(
                                      model.operations[index]),
                                )
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
            );
          });
}
