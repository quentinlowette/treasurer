import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/widgets/accountHeader.dart';
import 'package:treasurer/ui/widgets/operationTile.dart';

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
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () => model.newOperation(),
                                  ),
                                ],
                              ),
                              AccountHeader(
                                model: model,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 0.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        height: 5.0,
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                            color: DefaultThemeColors.blueDD,
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        "Operations",
                                        style: Theme.of(context)
                                            .accentTextTheme
                                            .headline6,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: model.operations.length,
                                        itemBuilder: (context, index) =>
                                            OperationTile(
                                              operation:
                                                  model.operations[index],
                                              onTap: () =>
                                                  model.navigateToOperation(
                                                      model.operations[index]),
                                            ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            );
          });
}
