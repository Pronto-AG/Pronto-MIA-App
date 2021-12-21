import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/internal_news_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/image_service.dart';
import 'package:pronto_mia/ui/views/internal_news/view/internal_news_view.dart';
import 'package:stacked_services/stacked_services.dart';

/// A service, responsible for accessing internal news.
///
/// Contains methods to modify and access internal news information.
class InternalNewsService with ChangeNotifier {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  ImageService get _imageService => locator.get<ImageService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  /// Gets the list of all internal news.
  ///
  /// Returns a [List] list of internal news.
  Future<List<InternalNews>> getInternalNews() async {
    final data = await (await _graphQLService).query(
      InternalNewsQueries.internalNews,
    );

    final dtoList = data['internalNews'] as List<Object>;
    final internalNewsList = dtoList
        .map((dto) => InternalNews.fromJson(dto as Map<String, dynamic>))
        .toList();

    return internalNewsList;
  }

  /// Gets the list of all currently available internal news.
  ///
  /// Returns a [List] list of internal news.
  /// Currently available internal news include all internal news, which
  /// have an end date still in the future.
  Future<List<InternalNews>> getAvailableInternalNews() async {
    final data = await (await _graphQLService).query(
      InternalNewsQueries.internalNewsAvailable,
    );

    final dtoList = data['internalNews'] as List<Object>;
    final internalNewsList = dtoList
        .map((dto) => InternalNews.fromJson(dto as Map<String, dynamic>))
        .toList();

    return internalNewsList;
  }

  /// Gets the list of all internal news.
  ///
  /// Returns a [List] list of internal news.
  Future<InternalNews> getInternalNewsById(int id) async {
    final Map<String, dynamic> queryVariables = {
      'id': id,
    };

    final data = await (await _graphQLService)
        .query(InternalNewsQueries.internalNewsById, variables: queryVariables);

    final dtoList = data['internalNews'] as List<Object>;
    final internalNews = dtoList
        .map((dto) => InternalNews.fromJson(dto as Map<String, dynamic>))
        .first;

    return internalNews;
  }

  /// Gets the image of an internal news.
  ///
  /// Returns a [Image] of an internal news.
  Future<Image> getInternalNewsImage(InternalNews internalNews) async {
    final _imageFile = await _imageService.downloadImage(internalNews.link);
    return Image.memory(_imageFile.bytes);
  }

  /// Creates a new internal news.
  ///
  /// Takes different attributes of an internal news as an input.
  Future<void> createInternalNews(
    String title,
    String description,
    DateTime availableFrom,
    SimpleFile imageFile,
  ) async {
    final Map<String, dynamic> queryVariables = {
      'title': title,
      'description': description,
      'availableFrom': availableFrom.toIso8601String(),
    };

    queryVariables['file'] = http.MultipartFile.fromBytes(
      'file',
      imageFile.bytes,
      filename: imageFile.name,
      contentType: MediaType('image', 'png'),
    );

    await (await _graphQLService).mutate(
      InternalNewsQueries.createInternalNews,
      variables: queryVariables,
    );
  }

  /// Updates an existing internal news.
  ///
  /// Takes different attributes of the internal news to be updated as an input.
  Future<void> updateInternalNews(
    int id, {
    String title,
    String description,
    DateTime availableFrom,
    SimpleFile image,
  }) async {
    final Map<String, dynamic> queryVariables = {
      'id': id,
      'title': title,
      'description': description,
      'availableFrom': availableFrom?.toIso8601String(),
    };

    if (image != null) {
      queryVariables['file'] = http.MultipartFile.fromBytes(
        'image',
        image.bytes,
        filename: image.name,
        contentType: MediaType('image', 'png'),
      );
    }

    await (await _graphQLService).mutate(
      InternalNewsQueries.updateInternalNews,
      variables: queryVariables,
    );
  }

  /// Removes an existing internal news.
  ///
  /// Takes the [int] id of the internal news to be removed as an input.
  Future<void> removeInternalNews(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      InternalNewsQueries.removeInternalNews,
      variables: queryVariables,
    );
  }

  /// Publishes an existing internal news.
  ///
  /// Takes the [int] id of the internal news to be published, alongside a
  /// publish message consisting of a [String] title and [String] body as an
  /// input.
  Future<void> publishInternalNews(int id, String title, String body) async {
    final queryVariables = {
      'id': id,
      'title': title,
      'body': body,
    };
    await (await _graphQLService).mutate(
      InternalNewsQueries.publishInternalNews,
      variables: queryVariables,
    );
  }

  /// Unpublishes an existing internal news.
  ///
  /// Takes the [int] id of the internal news to not be published anymore as
  /// an input.
  Future<void> hideInternalNews(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      InternalNewsQueries.hideInternalNews,
      variables: queryVariables,
    );
  }

  /// Gets the news title from an internal news.
  ///
  /// Takes the [InternalNews] to get the title from as an input.
  /// Returns a [String] representation of the title.
  String getInternalNewsTitle(InternalNews internalNews) {
    return internalNews.title;
  }

  /// Gets the news date from an internal news.
  ///
  /// Takes the [InternalNews] to get the title from as an input.
  /// Returns a [String] representation of the date.
  String getInternalNewsDate(InternalNews internalNews) {
    return DateFormat.yMMMMd('de_CH')
        .addPattern('|')
        .add_Hm()
        .format(internalNews.availableFrom.toLocal());
  }

  /// Returns internal news based on a filter
  ///
  /// Takes the [String] name of the internal news to be filtered as an input.
  Future<List<InternalNews>> filterInternalNews(String filter) async {
    final queryVariables = {'filter': filter};
    final data = await (await _graphQLService).query(
      InternalNewsQueries.filterInternalNews,
      variables: queryVariables,
    );
    final dtoList = data['internalNews'] as List<Object>;
    final internalNewsList = dtoList
        .map((dto) => InternalNews.fromJson(dto as Map<String, dynamic>))
        .toList();
    return internalNewsList;
  }

  /// Opens a view, containing [InternalNews].
  ///
  /// Takes a [InternalNews].
  Future<void> openInternalNews(InternalNews internalNews) async {
    await _navigationService.navigateWithTransition(
      InternalNewsView(internalNews: internalNews),
      transition: NavigationTransition.LeftToRight,
    );
    return;
  }

  /// Notifies this objects listeners.
  void notifyDataChanged() {
    notifyListeners();
  }
}
