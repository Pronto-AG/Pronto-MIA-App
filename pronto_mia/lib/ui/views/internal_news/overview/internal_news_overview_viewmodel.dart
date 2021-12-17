import 'package:flutter/cupertino.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/internal_news_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/internal_news/edit/internal_news_edit_view.dart';
import 'package:pronto_mia/ui/views/internal_news/view/internal_news_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [InternalNewsView].
class InternalNewsOverviewViewModel
    extends FutureViewModel<List<InternalNews>> {
  static String contextIdentifier = "InternalNewsOverviewViewModel";
  // static const removeActionKey = 'RemoveActionKey';

  InternalNewsService get _internalNewsService =>
      locator.get<InternalNewsService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;
  bool isDialog;
  // final InternalNews internalNews;

  /// Initializes a new instance of [InternalNewsOverviewViewModel].
  ///
  /// Takes a [bool] wether to execute admin level functionality as an input.
  InternalNewsOverviewViewModel({
    this.adminModeEnabled = false,
    this.isDialog = false,
    // @required this.internalNews,
  }) {
    _internalNewsService.addListener(_notifyDataChanged);
  }

  /// Gets internal news and stores them into [data].
  ///
  /// Returns the fetched [List] of news.
  @override
  Future<List<InternalNews>> futureToRun() async {
    if (adminModeEnabled) {
      return _getInternalNews();
    } else {
      return _getAvailableInternalNews();
    }
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
      InternalNewsOverviewViewModel.contextIdentifier,
      error,
    );
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  /// Opens the form to create or update internal news.
  ///
  /// Takes the [InternalNews] to edit and a [bool] as an input wether the
  /// view should open as a dialog or standalone as an input.
  /// If the navigation or dialog resolve to data being changed, refetches
  /// the [List] of internal news.
  Future<void> editInternalNews({
    InternalNews internalNews,
    bool asDialog = false,
  }) async {
    bool dataHasChanged;
    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        // ignore: deprecated_member_use
        customData: InternalNewsEditView(
          internalNews: internalNews,
          isDialog: true,
        ),
      );
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse =
          await _navigationService.navigateWithTransition(
        InternalNewsEditView(internalNews: internalNews),
        transition: NavigationTransition.LeftToRight,
      );
      dataHasChanged = navigationResponse is bool && navigationResponse == true;
    }

    if (dataHasChanged) {
      await initialise();
    }
  }

  /// Opens the dialog to publish internal news.
  ///
  /// Takes the [InternalNews] to publish as an input.
  /// Refetches the [List] of internal news after the dialog has ended.
  Future<void> publishInternalNews(InternalNews internalNews) async {
    final internalNewsTitle = getInternalNewsTitle(internalNews);
    final response = await _dialogService.showConfirmationDialog(
      title: "Neuigkeit veröffentlichen",
      description: 'Wollen sie die Neuigkeit "$internalNewsTitle" '
          "wirklich veröffentlichen?",
      cancelTitle: "Nein",
      confirmationTitle: "Ja",
      dialogPlatform: DialogPlatform.Material,
    );

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _internalNewsService.publishInternalNews(
      internalNews.id,
      "Neuigkeit veröffentlicht",
      'Die Neuigkeit "$internalNewsTitle" wurde soeben veröffentlicht.',
    );

    await initialise();
  }

  /// Gets all internal news based on a filter.
  Future<List<InternalNews>> filterInternalNews(String filter) async =>
      _getFilteredInternalNews(filter);

  /// Opens the dialog to hide internal news.
  ///
  /// Takes the [InternalNews] to hide as an input.
  /// Refetches the [List] of internal news after the dialog has ended.
  Future<void> hideInternalNews(InternalNews internalNews) async {
    final internalNewsTitle = getInternalNewsTitle(internalNews);

    final response = await _dialogService.showConfirmationDialog(
      title: "Neuigkeit verstecken",
      description: 'Wollen sie die Neuigkeit "$internalNewsTitle" '
          "wirklich verstecken?",
      cancelTitle: "Nein",
      confirmationTitle: "Ja",
      dialogPlatform: DialogPlatform.Material,
    );

    if (!(response?.confirmed ?? false)) {
      return;
    }

    await _internalNewsService.hideInternalNews(internalNews.id);
    await initialise();
  }

  Future<List<InternalNews>> _getAvailableInternalNews() async {
    return _internalNewsService.getAvailableInternalNews();
  }

  Future<List<InternalNews>> _getInternalNews() async {
    return _internalNewsService.getInternalNews();
  }

  Future<List<InternalNews>> _getFilteredInternalNews(String filter) async {
    return _internalNewsService.filterInternalNews(filter);
  }

  Future<Image> getInternalNewsImage(InternalNews internalNews) async {
    return _internalNewsService.getInternalNewsImage(internalNews);
  }

  /// Generates a title for an internal news
  ///
  /// Takes the [InternalNews] to generate the title for as an input.
  /// Returns the generated [String] title.
  String getInternalNewsTitle(InternalNews internalNews) {
    return _internalNewsService.getInternalNewsTitle(internalNews);
  }

  /// Generates a date string for an internal news
  ///
  /// Takes the [InternalNews] to generate the title for as an input.
  /// Returns the generated [String] date.
  String getInternalNewsDate(InternalNews internalNews) {
    return _internalNewsService.getInternalNewsDate(internalNews);
  }

  /// Refetches the [List] of deployment plans.
  void _notifyDataChanged() {
    initialise();
  }

  /// Removes the listener on [InternalNewsService].
  @override
  void dispose() {
    _internalNewsService.removeListener(_notifyDataChanged);
    super.dispose();
  }

  void openInternalNews(InternalNews internalNews) {
    _navigationService.navigateWithTransition(
      InternalNewsView(internalNews: internalNews),
    );
  }

  /// Removes the [InternalNews] contained in the form.
  ///
  /// After the [InternalNews] has been removed successfully, closes dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeInternalNews(InternalNews internalNews) async {
    if (internalNews != null) {
      await runBusyFuture(
        _internalNewsService.removeInternalNews(internalNews.id),
      );
    }
  }

  Future<void> removeItems(List<InternalNews> selectedToDelete) async {
    for (var i = 0; i < selectedToDelete.length; i++) {
      removeInternalNews(selectedToDelete[i]);
      data?.remove(selectedToDelete[i]);
    }
  }
}
