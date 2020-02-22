import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/widgets/accountHeader.dart';
import 'package:treasurer/ui/widgets/operationTile.dart';

/// View of an account
class AccountView extends StatelessWidget {
  List<Widget> _getBody(BuildContext context, AccountViewModel model) {
    List<Widget> operationTiles =
        model.operations.map((op) => OperationTile(operation: op)).toList();
    return operationTiles;
  }

  @override
  Widget build(BuildContext context) => ViewModelProvider<
          AccountViewModel>.withConsumer(
      viewModel: AccountViewModel(),
      onModelReady: (model) => model.loadData(),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(
                            MediaQuery.of(context).size.width * 0.5, 32),
                        bottomRight: Radius.elliptical(
                            MediaQuery.of(context).size.width * 0.5, 32))),
              ),
              SafeArea(
                child: !model.isLoaded
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${model.total} €",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "Cash",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0),
                                          ),
                                          Text(
                                            "${model.cash} €",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            "Bank",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0),
                                          ),
                                          Text(
                                            "${model.bank} €",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(children: _getBody(context, model)),
                            )
                          ],
                        ),
                      ),
              )
            ],
          ),
        );
      });
}
