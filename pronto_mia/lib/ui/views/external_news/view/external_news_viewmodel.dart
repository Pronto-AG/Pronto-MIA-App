import 'package:flutter/cupertino.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/external_news_service.dart';
import 'package:stacked/stacked.dart';

/// A view model, providing functionality for [ExternalNewsView].
class ExternalNewsViewModel extends FutureViewModel<ExternalNews> {
  static String contextIdentifier = "ExternalNewsViewModel";
  ExternalNews externalNews;

  ExternalNewsService get _externalNewsService =>
      locator.get<ExternalNewsService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;

  /// Initializes a new instance of [ExternalNewsViewModel].
  ///
  /// Takes a [bool] wether to execute admin level functionality as an input.
  ExternalNewsViewModel({this.externalNews, this.adminModeEnabled = false}) {
    _externalNewsService.addListener(_notifyDataChanged);
  }

  /// Gets external news and stores them into [data].
  ///
  /// Returns the fetched [List] of news.
  @override
  Future<ExternalNews> futureToRun() async {
    return _getExternalNewsById(externalNews.id);
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
      ExternalNewsViewModel.contextIdentifier,
      error,
    );
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  Future<Image> getExternalNewsImage(ExternalNews externalNews) async {
    return _externalNewsService.getExternalNewsImage(externalNews);
  }

  /// Generates a title for a news article
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

  Future<ExternalNews> _getExternalNewsById(int id) async {
    return _externalNewsService.getExternalNewsById(id);
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

  void openExternalNews(ExternalNews externalNews) {}
}
