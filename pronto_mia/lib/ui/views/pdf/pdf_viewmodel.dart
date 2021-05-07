import 'package:logging/logging.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/services/logging_service.dart';

class PdfViewModel extends FutureViewModel<SimpleFile> {
  PdfService get _pdfService => locator.get<PdfService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  final SimpleFile pdfUpload;
  final String pdfPath;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  PdfViewModel({this.pdfUpload, this.pdfPath});

  @override
  Future<SimpleFile> futureToRun() {
    if (pdfUpload == null) {
      return _downloadPdf(pdfPath);
    }
    return Future.value();
  }

  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    _errorMessage = ErrorMessageFactory.getErrorMessage(error);
    (await _loggingService).log("PdfViewModel", Level.WARNING, error);
  }

  Future<SimpleFile> _downloadPdf(String path) async {
    return _pdfService.downloadPdf(path);
  }
}
