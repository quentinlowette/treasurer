import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:treasurer/core/services/locator.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/colors.dart';
import 'package:treasurer/ui/widgets/accountHeader.dart';
import 'package:treasurer/ui/widgets/operationTile.dart';

/// View of an account
class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      ViewModelProvider<AccountViewModel>.withConsumer(
          viewModel: locator<AccountViewModel>(),
          reuseExisting: true,
          onModelReady: (model) => model.loadData(),
          builder: (context, model, child) {
            return Scaffold(
              // backgroundColor: Theme.of(context).accentColor,
              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.centerFloat,
              // floatingActionButton: !model.isLoaded
              //     ? null
              //     : FloatingActionButton(
              //         onPressed: () =>
              //             Navigator.of(context).pushNamed('/addOperation'),
              //         child: Icon(Icons.add),
              //         backgroundColor: Theme.of(context).accentColor,
              //       ),
              // appBar: !model.isLoaded
              //     ? null
              //     : AppBar(
              //         actions: <Widget>[
              //           IconButton(
              //             icon: Icon(Icons.add),
              //             onPressed: () =>
              //                 Navigator.of(context).pushNamed('/addOperation'),
              //           )
              //         ],
              //       ),
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
                                    onPressed: () => Navigator.of(context).pushNamed('/addOperation'),
                                  ),
                                ],
                              ),
                              AccountHeader(
                                model: model,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
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
                                      height: 20.0,
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
                                                    model.operations[index]))
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
