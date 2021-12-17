import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/core/services/educational_content_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/educational_content/edit/educational_content_edit_view.dart';
import 'package:pronto_mia/ui/views/educational_content/view/educational_content_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [EducationalContentView].
class EducationalContentOverviewViewModel
    extends FutureViewModel<List<EducationalContent>> {
  static String contextIdentifier = "EducationalContentOverviewViewModel";
  // static const removeActionKey = 'RemoveActionKey';

  EducationalContentService get _educationalContentService =>
      locator.get<EducationalContentService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;
  bool isDialog;
  // final EducationalContent educationalContent;

  /// Initializes a new instance of [EducationalContentOverviewViewModel].
  ///
  /// Takes a [bool] wether to execute admin level functionality as an input.
  EducationalContentOverviewViewModel({
    this.adminModeEnabled = false,
    this.isDialog = false,
    // @required this.educationalContent,
  }) {
    _educationalContentService.addListener(_notifyDataChanged);
  }

  /// Gets educational content and stores them into [data].
  ///
  /// Returns the fetched [List] of news.
  @override
  Future<List<EducationalContent>> futureToRun() async {
    if (adminModeEnabled) {
      return _getEducationalContent();
    } else {
      return _getAvailableEducationalContent();
    }
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
      EducationalContentOverviewViewModel.contextIdentifier,
      error,
    );
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  /// Opens the form to create or update educational content.
  ///
  /// Takes the [EducationalContent] to edit and a [bool] as an input wether the
  /// view should open as a dialog or standalone as an input.
  /// If the navigation or dialog resolve to data being changed, refetches
  /// the [List] of educational content.
  Future<void> editEducationalContent({
    EducationalContent educationalContent,
    bool asDialog = false,
  }) async {
    bool dataHasChanged;
    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        // ignore: deprecated_member_use
        customData: EducationalContentEditView(
          educationalContent: educationalContent,
          isDialog: true,
        ),
      );
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse =
          await _navigationService.navigateWithTransition(
        EducationalContentEditView(educationalContent: educationalContent),
        transition: NavigationTransition.LeftToRight,
      );
      dataHasChanged = navigationResponse is bool && navigationResponse == true;
    }

    if (dataHasChanged) {
      await initialise();
    }
  }

  /// Opens the dialog to publish educational content.
  ///
  /// Takes the [EducationalContent] to publish as an input.
  /// Refetches the [List] of educational content after the dialog has ended.
  Future<void> publishEducationalContent(
    EducationalContent educationalContent,
  ) async {
    final educationalContentTitle =
        getEducationalContentTitle(educationalContent);
    final response = await _dialogService.showConfirmationDialog(
      title: "Schulungsvideo veröffentlichen",
      description: 'Wollen sie das Schulungsvideo "$educationalContentTitle" '
          "wirklich veröffentlichen?",
      cancelTitle: "Nein",
      confirmationTitle: "Ja",
      dialogPlatform: DialogPlatform.Material,
    );

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _educationalContentService.publishEducationalContent(
      educationalContent.id,
      "Schulungsvideo veröffentlicht",
      'Das Schulungsvideo "$educationalContentTitle" wurde veröffentlicht.',
    );

    await initialise();
  }

  /// Gets all educational content based on a filter.
  Future<List<EducationalContent>> filterEducationalContent(
    String filter,
  ) async =>
      _getFilteredEducationalContent(filter);

  /// Opens the dialog to hide educational content.
  ///
  /// Takes the [EducationalContent] to hide as an input.
  /// Refetches the [List] of educational content after the dialog has ended.
  Future<void> hideEducationalContent(
    EducationalContent educationalContent,
  ) async {
    final educationalContentTitle =
        getEducationalContentTitle(educationalContent);

    final response = await _dialogService.showConfirmationDialog(
      title: "Schulungsvideo verstecken",
      description: 'Wollen sie das Schulungsvideo "$educationalContentTitle" '
          "wirklich verstecken?",
      cancelTitle: "Nein",
      confirmationTitle: "Ja",
      dialogPlatform: DialogPlatform.Material,
    );

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _educationalContentService
        .hideEducationalContent(educationalContent.id);
    await initialise();
  }

  Future<List<EducationalContent>> _getAvailableEducationalContent() async {
    return _educationalContentService.getAvailableEducationalContent();
  }

  Future<List<EducationalContent>> _getEducationalContent() async {
    return _educationalContentService.getEducationalContent();
  }

  Future<List<EducationalContent>> _getFilteredEducationalContent(
    String filter,
  ) async {
    return _educationalContentService.filterEducationalContent(filter);
  }

  /// Generates a title for an educational content
  ///
  /// Takes the [EducationalContent] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getEducationalContentTitle(EducationalContent eN) {
    return _educationalContentService.getEducationalContentTitle(eN);
  }

  /// Generates a file extension for an educational content
  ///
  /// Takes the [EducationalContent] to generate the file extension for
  /// as an input.
  /// Returns the generated [String] file extension.
  String getEducationalContentFileExtension(
    EducationalContent educationalContent,
  ) {
    return _educationalContentService
        .getEducationalContentFileExtension(educationalContent);
  }

  /// Opens a view, containing a pdf file from a [EducationalContent].
  ///
  /// Takes a [EducationalContent], containing a pdf file as an input.
  Future<void> openPdf(EducationalContent educationalContent) async {
    _educationalContentService.openPdf(educationalContent);
  }

  /// Refetches the [List] of deployment plans.
  void _notifyDataChanged() {
    initialise();
  }

  /// Removes the listener on [EducationalContentService].
  @override
  void dispose() {
    _educationalContentService.removeListener(_notifyDataChanged);
    super.dispose();
  }

  void openEducationalContent(EducationalContent educationalContent) {
    _navigationService.navigateWithTransition(
      EducationalContentView(educationalContent: educationalContent),
    );
  }

  /// Removes the [EducationalContent] contained in the form.
  ///
  /// After the [EducationalContent] has been removed successfully, close dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeEducationalContent(
    EducationalContent educationalContent,
  ) async {
    if (educationalContent != null) {
      await runBusyFuture(
        _educationalContentService
            .removeEducationalContent(educationalContent.id),
      );
    }
  }

  Future<void> removeItems(List<EducationalContent> selectedToDelete) async {
    for (var i = 0; i < selectedToDelete.length; i++) {
      removeEducationalContent(selectedToDelete[i]);
      data?.remove(selectedToDelete[i]);
    }
  }
}
