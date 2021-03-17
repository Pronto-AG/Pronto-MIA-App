import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'counter_viewmodel.dart';

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CounterViewModel(),
      onModelReady: (model) => model.loadData(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${model.counter}',
                style: Theme.of(context).textTheme.display1
              )
            ]
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            model.increment();
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ));
  }
}