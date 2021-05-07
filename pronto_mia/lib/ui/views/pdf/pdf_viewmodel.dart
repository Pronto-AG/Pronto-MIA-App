import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/services/logging_service.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';

class PdfViewModel extends FutureViewModel<SimpleFile> {
  PdfService get _pdfService => locator.get<PdfService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  final Object pdfFile;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  PdfViewModel({@required this.pdfFile});

  @override
  Future<SimpleFile> futureToRun() {
    switch (pdfFile.runtimeType) {
      case String:
        return _pdfService.downloadPdf(pdfFile as String);
      case SimpleFile:
        return Future.value(pdfFile as SimpleFile);
      default:
        throw AssertionError(
          'Argument pdfFile has to be either String or SimpleFile',
        );
    }
  }

  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    _errorMessage = ErrorMessageFactory.getErrorMessage(error);
    (await _loggingService).log('PdfViewModel', Level.WARNING, error);
  }
}
