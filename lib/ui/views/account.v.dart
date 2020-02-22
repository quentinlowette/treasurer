import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';
import 'package:treasurer/ui/widgets/accountHeader.dart';
import 'package:treasurer/ui/widgets/operationTile.dart';

/// View of an account
class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      ViewModelProvider<AccountViewModel>.withConsumer(
          viewModel: AccountViewModel(),
          onModelReady: (model) => model.loadData(),
          builder: (context, model, child) => Scaffold(
              // If operations not loaded
              body: model.operations == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(
                      children: <Widget>[
                        AccountHeader(),
                        SafeArea(
                          child: ListView.builder(
                              itemCount: model.operations.length,
                              itemBuilder: (context, index) {
                                return OperationTile(
                                    operation: model.operations[index]);
                              })),
                        Positioned(
                          top: 30,
                          left: 5,
                          child: IconButton(
                            icon: Icon(Icons.exit_to_app),
                            onPressed: () {
                              print("logout");
                            },
                          ),
                        ),
                        Positioned(
                          top: 30,
                          right: 5,
                          child: IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              print("settings");
                            },
                          ),
                        ),
                      ],
                    )));
}
