import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  final String name;

  const HomeView({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.loadCounter(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(model.title),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text('${model.counter}')
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          onPressed: model.incrementCounter,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: model.getData,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Einsatzpläne',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.beach_access), label: 'Urlaub'),
            BottomNavigationBarItem(
                icon: Icon(Icons.school), label: 'Schulung'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'News')
          ],
          selectedItemColor: Colors.amber[800],
        ),
      ),
    );
  }
}
