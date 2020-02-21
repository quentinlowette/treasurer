import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:treasurer/core/viewmodels/account.vm.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ViewModelProvider<AccountViewModel>.withConsumer(
    viewModel: AccountViewModel(),
    onModelReady: (model) => model.loadData(),
    builder: (context, model, child) => Scaffold(
      body: model.operations == null ? Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(
        itemCount: model.operations.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(model.operations[index].description),
          subtitle: Text(model.operations[index].amount.toString()),
        )
      )
    )
  );
}
