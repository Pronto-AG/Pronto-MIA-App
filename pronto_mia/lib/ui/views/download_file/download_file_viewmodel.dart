import 'dart:io';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';

class DownloadFileViewModel extends BaseViewModel {
  final PdfService _pdfService = locator<PdfService>();

  File _file;
  File get file => _file;

  Future<void> downloadFile() async {
    _file = await _pdfService.downloadPdf();
    notifyListeners();
  }
}
