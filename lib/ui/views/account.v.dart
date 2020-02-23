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
  Widget build(BuildContext context) =>
      ViewModelProvider<AccountViewModel>.withConsumer(
          viewModel: AccountViewModel(),
          onModelReady: (model) => model.loadData(),
          builder: (context, model, child) {
            return Scaffold(
              backgroundColor: Colors.deepOrange,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  print("fab");
                },
                child: Icon(Icons.add),
              ),
              body: !model.isLoaded
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AccountHeader(model: model,),
                              Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        height: 5.0,
                                        width: 60.0,
                                        decoration: BoxDecoration(
                                          color: Colors.black26,
                                          borderRadius: BorderRadius.circular(5.0)
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0,),
                                    Text("Operations", style: Theme.of(context).textTheme.headline6,),
                                    SizedBox(height: 10.0,),
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
