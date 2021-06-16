import 'package:stacked/stacked.dart';
import 'package:flutter/foundation.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/models/simple_file.dart';

class PdfViewModel extends FutureViewModel<SimpleFile> {
  static String contextIdentifier = "PdfViewModel";

  PdfService get _pdfService => locator.get<PdfService>();
  ErrorService get _errorService => locator.get<ErrorService>();

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
    await _errorService.handleError(PdfViewModel.contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }
}
