import 'package:flutter/foundation.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:stacked/stacked.dart';

/// A view model, providing functionality for [PdfView].
class PdfViewModel extends FutureViewModel<SimpleFile> {
  static String contextIdentifier = "PdfViewModel";

  PdfService get _pdfService => locator.get<PdfService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final Object pdfFile;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  /// Initializes a new instance of [PdfViewModel].
  ///
  /// Takes the pdfFile to display of either type [String] or [SimpleFile] as
  /// an input.
  PdfViewModel({@required this.pdfFile});

  /// Gets the pdf file and stores them into [data].
  ///
  /// Returns the fetched [List] of departments.
  /// Throws error if the provided pdf file form the constructor is not either
  /// [String] or [SimpleFile].
  /// If the provied [pdfFile] is of type [String] the pdf gets downloaded and
  /// if its of type [SimpleFile] it its returned instead.
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

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(PdfViewModel.contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }
}
