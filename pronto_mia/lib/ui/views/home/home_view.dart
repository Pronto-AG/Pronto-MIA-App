import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/views/home/home_viewmodel.dart';
import 'package:pronto_mia/ui/views/download_file/download_file_view.dart';
import 'package:pronto_mia/ui/views/upload_file/upload_file_view.dart';

class HomeView extends StatelessWidget {
  final int routeIndex;

  const HomeView({Key key, this.routeIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: getViewForIndex(model.currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: model.currentIndex,
          onTap: model.setIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Hochladen',
              icon: Icon(Icons.file_upload),
            ),
            BottomNavigationBarItem(
              label: 'Anzeigen',
              icon: Icon(Icons.description),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  Widget getViewForIndex(int index) {
    var currentIndex = index;
    if (routeIndex != null) {
      currentIndex = routeIndex;
    }

    switch (currentIndex) {
      case 0:
        return const UploadFileView();
      case 1:
        return const DownloadFileView();
      default:
        return const UploadFileView();
    }
  }
}
