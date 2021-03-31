import 'dart:io';
import 'package:stacked/stacked.dart';

import 'package:informbob_app/app/app.locator.dart';
import 'package:informbob_app/core/services/file_service.dart';

class DownloadFileViewModel extends BaseViewModel {
  final FileService _fileService = locator<FileService>();

  File _file;
  File get file => _file;

  Future<void> downloadFile() async {
    _file = await _fileService.downloadFile();
    print(_file);
    notifyListeners();
  }
}