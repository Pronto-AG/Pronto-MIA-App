import 'package:informbob_app/ui/views/download_file/download_file_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

import 'package:informbob_app/ui/views/upload_file/upload_file_view.dart';

class HomeViewModel extends IndexTrackingViewModel {
  var _title = 'Datei hochladen';
  String get title => title;

  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        _title = 'Datei hochladen';
        return Text('upload');
      case 1:
        _title = 'Datei anzeigen';
        return Text('download');
      default:
        _title = 'Datei hochladen';
        return Text('upload');
    }
  }
}
