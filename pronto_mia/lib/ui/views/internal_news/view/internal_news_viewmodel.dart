import 'package:flutter/cupertino.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/internal_news_service.dart';
import 'package:stacked/stacked.dart';

/// A view model, providing functionality for [InternalNewsView].
class InternalNewsViewModel extends FutureViewModel<InternalNews> {
  static String contextIdentifier = "InternalNewsViewModel";
  InternalNews internalNews;

  InternalNewsService get _internalNewsService =>
      locator.get<InternalNewsService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool adminModeEnabled;
  String get errorMessage => _errorMessage;
  String _errorMessage;

  /// Initializes a new instance of [InternalNewsViewModel].
  ///
  /// Takes a [bool] wether to execute admin level functionality as an input.
  InternalNewsViewModel({this.internalNews, this.adminModeEnabled = false}) {
    _internalNewsService.addListener(_notifyDataChanged);
  }

  /// Gets internal news and stores them into [data].
  ///
  /// Returns the fetched [List] of news.
  @override
  Future<InternalNews> futureToRun() async {
    return _getInternalNewsById(internalNews.id);
  }

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
      InternalNewsViewModel.contextIdentifier,
      error,
    );
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  Future<Image> getInternalNewsImage(InternalNews internalNews) async {
    return _internalNewsService.getInternalNewsImage(internalNews);
  }

  /// Generates a title for a news article
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

  Future<InternalNews> _getInternalNewsById(int id) async {
    return _internalNewsService.getInternalNewsById(id);
  }

  /// Refetches the [List] of internal news.
  void _notifyDataChanged() {
    initialise();
  }

  /// Removes the listener on [InternalNewsService].
  @override
  void dispose() {
    _internalNewsService.removeListener(_notifyDataChanged);
    super.dispose();
  }

  void openInternalNews(InternalNews internalNews) {}
}
