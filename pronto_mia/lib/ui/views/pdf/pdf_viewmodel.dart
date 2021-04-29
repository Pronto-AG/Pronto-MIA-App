import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:logging/logging.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';

class PdfViewModel extends FutureViewModel<File> {
  PdfService get _pdfService => locator.get<PdfService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator.get<ErrorMessageFactory>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  final PlatformFile pdfUpload;
  final String pdfPath;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  PdfViewModel({this.pdfUpload, this.pdfPath});

  @override
  Future<File> futureToRun() {
    if (pdfUpload == null) {
      return _downloadPdf(pdfPath);
    }
    return Future.value();
  }

  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    _errorMessage = _errorMessageFactory.getErrorMessage(error);
    (await _loggingService).log("PdfViewModel", Level.WARNING, error);
  }

  Future<File> _downloadPdf(String path) async {
    return _pdfService.downloadPdf(path);
  }
}
