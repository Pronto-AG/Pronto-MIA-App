import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:informbob_app/ui/views/home/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(model.title),
        ),
        body: model.getViewForIndex(0),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: model.currentIndex,
          onTap: model.setIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.file_upload),
              label: 'Hochladen',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'Anzeigen',
            )
          ],
        ),
      ),
    );
  }
}
