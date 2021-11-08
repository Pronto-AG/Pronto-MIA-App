import 'package:flutter/foundation.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/external_news_service.dart';
import 'package:pronto_mia/ui/views/external_news/edit/external_news_edit_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [ExternalNewsEditView].
class ExternalNewsEditViewModel extends FormViewModel {
  static const contextIdentifier = "ExternalNewsEditViewModel";
  static const editActionKey = 'EditActionKey';
  static const removeActionKey = 'RemoveActionKey';

  ExternalNewsService get _externalNewsService =>
      locator.get<ExternalNewsService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool isDialog;
  final ExternalNews externalNews;
  SimpleFile get imageFile => _imageFile;
  SimpleFile _imageFile;

  /// Initializes a new instance of [ExternalNewsEditViewModel]
  ///
  /// Takes the [ExternalNews] to edit and a [bool] wether the form should be
  /// displayed as a dialog or standalone as an input.
  ExternalNewsEditViewModel({
    @required this.externalNews,
    this.isDialog = false,
  });

  /// Resets errors and messages, as soon as form fields update.
  @override
  void setFormStatus() {
    clearErrors();
  }

  /// Sets the image file.
  ///
  /// Takes the [SimpleFile] image to set as an input.
  void setImageUpload(SimpleFile fileUpload) {
    _imageFile = fileUpload;
    notifyListeners();
  }

  /// Opens a pdf view, either from the file picker or deployment plan.
  Future<void> openImage() async {
    return;
  }

  /// Validates the form and either creates or updates a [ExternalNews].
  ///
  /// After the form has been submitted successfully, it closes the dialog in
  /// case it was opened as a dialog or navigates to the previous view if
  /// opened as standalone.
  Future<void> submitForm() async {
    final validationMessage = _validateForm();
    if (validationMessage != null) {
      setValidationMessage(validationMessage);
      notifyListeners();
      return;
    }

    final availableFrom = DateTime.parse(availableFromValue);

    if (externalNews == null) {
      await runBusyFuture(
        _externalNewsService.createExternalNews(
          titleValue,
          descriptionValue,
          availableFrom,
          _imageFile,
        ),
        busyObject: editActionKey,
      );
    } else {
      await runBusyFuture(
        _externalNewsService.updateExternalNews(
          externalNews.id,
          externalNews.title != titleValue ? titleValue : null,
          externalNews.description != descriptionValue
              ? descriptionValue
              : null,
          !externalNews.availableFrom.isAtSameMomentAs(availableFrom)
              ? availableFrom
              : null,
          _imageFile,
        ),
        busyObject: editActionKey,
      );
    }

    _completeFormAction(editActionKey);
  }

  /// Removes the [ExternalNews] contained in the form.
  ///
  /// After the [ExternalNews] has been removed successfully, closes dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeExternalNews() async {
    if (externalNews != null) {
      await runBusyFuture(
        _externalNewsService.removeExternalNews(externalNews.id),
        busyObject: removeActionKey,
      );
    }

    _completeFormAction(removeActionKey);
  }

  /// Generates a title for a external news
  ///
  /// Takes the [ExternalNews] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getExternalNewsTitle(ExternalNews externalNews) {
    return _externalNewsService.getExternalNewsTitle(externalNews);
  }

  String _validateForm() {
    if (titleValue == null || titleValue.isEmpty) {
      return 'Bitte Titel eingeben.';
    }

    if (descriptionValue == null || descriptionValue.isEmpty) {
      return 'Bitte Beschreibung eingeben.';
    }

    if (availableFromValue == null || availableFromValue.isEmpty) {
      return 'Bitte Startdatum eingeben.';
    }

    if (imagePathValue == null || imagePathValue.isEmpty) {
      return 'Bitte Neuigkeiten Bild als PNG-Datei hochladen.';
    }

    return null;
  }

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        ExternalNewsEditViewModel.contextIdentifier,
        error(actionKey),
      );
      final errorMessage = _errorService.getErrorMessage(error(actionKey));
      setValidationMessage(errorMessage);
      notifyListeners();
    } else if (isDialog) {
      _dialogService.completeDialog(DialogResponse(confirmed: true));
    } else {
      _navigationService.back(result: true);
    }
  }
}
