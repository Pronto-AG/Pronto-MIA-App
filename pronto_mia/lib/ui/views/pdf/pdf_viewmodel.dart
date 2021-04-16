import 'dart:io';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';

class PdfViewModel extends FutureViewModel<File> {
  PdfService get _pdfService => locator<PdfService>();
  ErrorMessageFactory get _errorMessageFactory =>
      locator<ErrorMessageFactory>();

  final String pdfPath;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  PdfViewModel({@required this.pdfPath});

  @override
  Future<File> futureToRun() => _downloadPdf(pdfPath);

  @override
  void onError(dynamic error) {
    _errorMessage = _errorMessageFactory.getErrorMessage(error);
  }

  Future<File> _downloadPdf(String path) async {
    return _pdfService.downloadPdf(path);
  }
}
