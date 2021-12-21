import 'package:flutter/foundation.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/services/educational_content_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/views/educational_content/edit/educational_content_edit_view.form.dart';
import 'package:pronto_mia/ui/views/educational_content/overview/educational_content_overview_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [EducationalContentEditView].
class EducationalContentEditViewModel extends FormViewModel {
  static const contextIdentifier = "EducationalContentEditViewModel";
  static const editActionKey = 'EditActionKey';
  static const removeActionKey = 'RemoveActionKey';

  EducationalContentService get _educationalContentService =>
      locator.get<EducationalContentService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool isDialog;
  final EducationalContent educationalContent;
  SimpleFile get file => _file;
  SimpleFile _file;

  /// Initializes a new instance of [EducationalContentEditViewModel]
  ///
  /// Takes the [EducationalContent] to edit and a [bool] wether the form should
  ///  be displayed as a dialog or standalone as an input.
  EducationalContentEditViewModel({
    @required this.educationalContent,
    this.isDialog = false,
  });

  /// Resets errors and messages, as soon as form fields update.
  @override
  void setFormStatus() {
    clearErrors();
  }

  /// Sets the video file.
  ///
  /// Takes the [SimpleFile] video to set as an input.
  void setVideoUpload(SimpleFile fileUpload) {
    _file = fileUpload;
    notifyListeners();
  }

  /// Validates the form and either creates or updates a [EducationalContent].
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

    if (educationalContent == null) {
      await runBusyFuture(
        _educationalContentService.createEducationalContent(
          titleValue,
          descriptionValue,
          _file,
        ),
        busyObject: editActionKey,
      );
    } else {
      await runBusyFuture(
        _educationalContentService.updateEducationalContent(
          educationalContent.id,
          title: educationalContent.title != titleValue ? titleValue : null,
          description: educationalContent.description != descriptionValue
              ? descriptionValue
              : null,
          file: _file,
        ),
        busyObject: editActionKey,
      );
    }

    _completeFormAction(editActionKey);
  }

  /// Removes the [EducationalContent] contained in the form.
  ///
  /// After the [EducationalContent] has been removed successfully, close dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeEducationalContent() async {
    if (educationalContent != null) {
      await runBusyFuture(
        _educationalContentService
            .removeEducationalContent(educationalContent.id),
        busyObject: removeActionKey,
      );
    }

    _completeFormAction(removeActionKey);
  }

  /// Generates a title for a educational content
  ///
  /// Takes the [EducationalContent] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getEducationalContentTitle(EducationalContent educationalContent) {
    return _educationalContentService
        .getEducationalContentTitle(educationalContent);
  }

  String _validateForm() {
    if (titleValue == null || titleValue.isEmpty) {
      return 'Bitte Titel eingeben.';
    }

    if (descriptionValue == null || descriptionValue.isEmpty) {
      return 'Bitte Beschreibung eingeben.';
    }

    if (videoPathValue == null || videoPathValue.isEmpty) {
      return 'Bitte Schulungsvideo als MP4-Datei hochladen.';
    }

    return null;
  }

  void cancelForm() {
    _navigationService.replaceWithTransition(
      const EducationalContentOverviewView(adminModeEnabled: true),
    );
  }

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        EducationalContentEditViewModel.contextIdentifier,
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
