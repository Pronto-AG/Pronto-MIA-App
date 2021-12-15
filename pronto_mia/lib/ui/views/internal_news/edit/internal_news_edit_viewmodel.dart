import 'package:flutter/foundation.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/internal_news_service.dart';
import 'package:pronto_mia/ui/views/internal_news/edit/internal_news_edit_view.form.dart';
import 'package:pronto_mia/ui/views/internal_news/overview/internal_news_overview_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [InternalNewsEditView].
class InternalNewsEditViewModel extends FormViewModel {
  static const contextIdentifier = "InternalNewsEditViewModel";
  static const editActionKey = 'EditActionKey';
  static const removeActionKey = 'RemoveActionKey';

  InternalNewsService get _internalNewsService =>
      locator.get<InternalNewsService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool isDialog;
  final InternalNews internalNews;
  SimpleFile get imageFile => _imageFile;
  SimpleFile _imageFile;

  /// Initializes a new instance of [InternalNewsEditViewModel]
  ///
  /// Takes the [InternalNews] to edit and a [bool] wether the form should be
  /// displayed as a dialog or standalone as an input.
  InternalNewsEditViewModel({
    @required this.internalNews,
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

  /// Opens an image
  Future<void> openImage() async {
    /// TODO
    return;
  }

  /// Validates the form and either creates or updates a [InternalNews].
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

    if (internalNews == null) {
      await runBusyFuture(
        _internalNewsService.createInternalNews(
          titleValue,
          descriptionValue,
          availableFrom,
          _imageFile,
        ),
        busyObject: editActionKey,
      );
    } else {
      await runBusyFuture(
        _internalNewsService.updateInternalNews(
          internalNews.id,
          internalNews.title != titleValue ? titleValue : null,
          internalNews.description != descriptionValue
              ? descriptionValue
              : null,
          !internalNews.availableFrom.isAtSameMomentAs(availableFrom)
              ? availableFrom
              : null,
          _imageFile,
        ),
        busyObject: editActionKey,
      );
    }

    _completeFormAction(editActionKey);
  }

  /// Removes the [InternalNews] contained in the form.
  ///
  /// After the [InternalNews] has been removed successfully, closes dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeInternalNews() async {
    if (internalNews != null) {
      await runBusyFuture(
        _internalNewsService.removeInternalNews(internalNews.id),
        busyObject: removeActionKey,
      );
    }

    _completeFormAction(removeActionKey);
  }

  /// Generates a title for a internal news
  ///
  /// Takes the [InternalNews] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getInternalNewsTitle(InternalNews internalNews) {
    return _internalNewsService.getInternalNewsTitle(internalNews);
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

  void cancelForm() {
    _navigationService.replaceWithTransition(
      const InternalNewsOverviewView(adminModeEnabled: true),
    );
  }

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        InternalNewsEditViewModel.contextIdentifier,
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
