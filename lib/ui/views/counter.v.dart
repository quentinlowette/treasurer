import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:treasurer/core/viewmodels/counter.vm.dart';

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ViewModelProvider<CounterViewModel>.withConsumer(
    viewModel: CounterViewModel(),
    onModelReady: (model) => model.loadData(),
    builder: (context, model, child) => Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text('${model.counter}', style: Theme.of(context).textTheme.headline4,)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          model.increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    )
  );
}
