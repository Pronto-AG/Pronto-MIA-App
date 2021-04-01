import 'dart:io';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/file_service.dart';

class DownloadFileViewModel extends BaseViewModel {
  final FileService _fileService = locator<FileService>();

  File _file;
  File get file => _file;

  Future<void> downloadFile() async {
    _file = await _fileService.downloadFile();
    notifyListeners();
  }
}