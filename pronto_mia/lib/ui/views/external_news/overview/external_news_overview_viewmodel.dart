import 'package:flutter/cupertino.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/external_news_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/external_news/edit/external_news_edit_view.dart';
import 'package:pronto_mia/ui/views/external_news/view/external_news_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [ExternalNewsView].
class ExternalNewsOverviewViewModel
    extends FutureViewModel<List<ExternalNews>> {
  static String contextIdentifier = "ExternalNewsOverviewViewModel";

  ExternalNewsService get _externalNewsService =>
      locator.get<ExternalNewsService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;
  bool isDialog;

  /// Initializes a new instance of [ExternalNewsOverviewViewModel].
  ///
  /// Takes a [bool] wether to execute admin level functionality as an input.
  ExternalNewsOverviewViewModel({
    this.adminModeEnabled = false,
    this.isDialog = false,
    // @required this.externalNews,
  }) {
    _externalNewsService.addListener(_notifyDataChanged);
  }

  /// Gets external news and stores them into [data].
  ///
  /// Returns the fetched [List] of news.
  @override
  Future<List<ExternalNews>> futureToRun() async {
    if (adminModeEnabled) {
      return _getExternalNews();
    } else {
      return _getAvailableExternalNews();
    }
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
      ExternalNewsOverviewViewModel.contextIdentifier,
      error,
    );
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  /// Opens the form to create or update external news.
  ///
  /// Takes the [ExternalNews] to edit and a [bool] as an input wether the
  /// view should open as a dialog or standalone as an input.
  /// If the navigation or dialog resolve to data being changed, refetches
  /// the [List] of deployment plans.
  Future<void> editExternalNews({
    ExternalNews externalNews,
    bool asDialog = false,
  }) async {
    bool dataHasChanged;
    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        // ignore: deprecated_member_use
        customData: ExternalNewsEditView(
          externalNews: externalNews,
          isDialog: true,
        ),
      );
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse =
          await _navigationService.navigateWithTransition(
        ExternalNewsEditView(externalNews: externalNews),
        transition: NavigationTransition.LeftToRight,
      );
      dataHasChanged = navigationResponse is bool && navigationResponse == true;
    }

    if (dataHasChanged) {
      await initialise();
    }
  }

  /// Opens the dialog to publish external news.
  ///
  /// Takes the [ExternalNews] to publish as an input.
  /// Refetches the [List] of external news after the dialog has ended.
  Future<void> publishExternalNews(ExternalNews externalNews) async {
    final externalNewsTitle = getExternalNewsTitle(externalNews);
    final response = await _dialogService.showConfirmationDialog(
      title: "Neuigkeit veröffentlichen",
      description: 'Wollen sie die Neuigkeit "$externalNewsTitle" '
          "wirklich veröffentlichen?",
      cancelTitle: "Nein",
      confirmationTitle: "Ja",
      dialogPlatform: DialogPlatform.Material,
    );

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _externalNewsService.publishExternalNews(
      externalNews.id,
      "Neuigkeit veröffentlicht",
      'Die Neuigkeit "$externalNewsTitle" wurde soeben veröffentlicht.',
    );

    await initialise();
  }

  /// Gets all external news based on a filter.
  Future<List<ExternalNews>> filterExternalNews(String filter) async =>
      _getFilteredExternalNews(filter);

  /// Opens the dialog to hide external news.
  ///
  /// Takes the [ExternalNews] to hide as an input.
  /// Refetches the [List] of external news after the dialog has ended.
  Future<void> hideExternalNews(ExternalNews externalNews) async {
    final externalNewsTitle = getExternalNewsTitle(externalNews);

    final response = await _dialogService.showConfirmationDialog(
      title: "Neuigkeit verstecken",
      description: 'Wollen sie die Neuigkeit "$externalNewsTitle" '
          "wirklich verstecken?",
      cancelTitle: "Nein",
      confirmationTitle: "Ja",
      dialogPlatform: DialogPlatform.Material,
    );

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _externalNewsService.hideExternalNews(externalNews.id);
    await initialise();
  }

  Future<List<ExternalNews>> _getAvailableExternalNews() async {
    return _externalNewsService.getAvailableExternalNews();
  }

  Future<List<ExternalNews>> _getExternalNews() async {
    return _externalNewsService.getExternalNews();
  }

  Future<List<ExternalNews>> _getFilteredExternalNews(String filter) async {
    return _externalNewsService.filterExternalNews(filter);
  }

  Future<Image> getExternalNewsImage(ExternalNews externalNews) async {
    return _externalNewsService.getExternalNewsImage(externalNews);
  }

  /// Generates a title for an external news
  ///
  /// Takes the [ExternalNews] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getExternalNewsTitle(ExternalNews eN) {
    return _externalNewsService.getExternalNewsTitle(eN);
  }

  /// Generates a date string for an external news
  ///
  /// Takes the [ExternalNews] to generate the title for as an input.
  /// Returns the generated [String] date.
  String getExternalNewsDate(ExternalNews eN) {
    return _externalNewsService.getExternalNewsDate(eN);
  }

  /// Refetches the [List] of deployment plans.
  void _notifyDataChanged() {
    initialise();
  }

  /// Removes the listener on [ExternalNewsService].
  @override
  void dispose() {
    _externalNewsService.removeListener(_notifyDataChanged);
    super.dispose();
  }

  void openExternalNews(ExternalNews externalNews) {
    _navigationService.navigateWithTransition(
      ExternalNewsView(externalNews: externalNews),
    );
  }

  /// Removes the [ExternalNews] contained in the form.
  ///
  /// After the [ExternalNews] has been removed successfully, closes dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeExternalNews(ExternalNews externalNews) async {
    if (externalNews != null) {
      await runBusyFuture(
        _externalNewsService.removeExternalNews(externalNews.id),
      );
    }
  }

  Future<void> removeItems(List<ExternalNews> selectedToDelete) async {
    for (var i = 0; i < selectedToDelete.length; i++) {
      removeExternalNews(selectedToDelete[i]);
      data.remove(selectedToDelete[i]);
    }
  }
}
