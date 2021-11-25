import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/external_news_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/image_service.dart';

/// A service, responsible for accessing external news.
///
/// Contains methods to modify and access external news information.
class ExternalNewsService with ChangeNotifier {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  ImageService get _imageService => locator.get<ImageService>();

  /// Gets the list of all external news.
  ///
  /// Returns a [List] list of external news.
  Future<List<ExternalNews>> getExternalNews() async {
    final data = await (await _graphQLService).query(
      ExternalNewsQueries.externalNews,
    );

    final dtoList = data['externalNews'] as List<Object>;
    final externalNewsList = dtoList
        .map((dto) => ExternalNews.fromJson(dto as Map<String, dynamic>))
        .toList();

    return externalNewsList;
  }

  /// Gets the list of all currently available external news.
  ///
  /// Returns a [List] list of external news.
  /// Currently available external news include all external news, which
  /// have an end date still in the future.
  Future<List<ExternalNews>> getAvailableExternalNews() async {
    final data = await (await _graphQLService).query(
      ExternalNewsQueries.externalNewsAvailable,
    );

    final dtoList = data['externalNews'] as List<Object>;
    final externalNewsList = dtoList
        .map((dto) => ExternalNews.fromJson(dto as Map<String, dynamic>))
        .toList();

    return externalNewsList;
  }

  /// Gets the list of all external news.
  ///
  /// Returns a [List] list of external news.
  Future<ExternalNews> getExternalNewsById(int id) async {
    final Map<String, dynamic> queryVariables = {
      'id': id,
    };

    final data = await (await _graphQLService)
        .query(ExternalNewsQueries.externalNewsById, variables: queryVariables);

    final dtoList = data['externalNews'] as List<Object>;
    final externalNews = dtoList
        .map((dto) => ExternalNews.fromJson(dto as Map<String, dynamic>))
        .first;

    return externalNews;
  }

  /// Gets the image of an external news.
  ///
  /// Returns a [Image] of an external news.
  Future<Image> getExternalNewsImage(ExternalNews externalNews) async {
    final _imageFile = await _imageService.downloadImage(externalNews.link);
    return Image.memory(_imageFile.bytes);
  }

  /// Creates a new external news.
  ///
  /// Takes different attributes of an external news as an input.
  Future<void> createExternalNews(
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
      ExternalNewsQueries.createExternalNews,
      variables: queryVariables,
    );
  }

  /// Updates an existing external news.
  ///
  /// Takes different attributes of the external news to be updated as an input.
  Future<void> updateExternalNews(
    int id,
    String title,
    String description,
    DateTime availableFrom,
    SimpleFile image,
  ) async {
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
      ExternalNewsQueries.updateExternalNews,
      variables: queryVariables,
    );
  }

  /// Removes an existing external news.
  ///
  /// Takes the [int] id of the external news to be removed as an input.
  Future<void> removeExternalNews(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      ExternalNewsQueries.removeExternalNews,
      variables: queryVariables,
    );
  }

  /// Publishes an existing external news.
  ///
  /// Takes the [int] id of the external news to be published, alongside a
  /// publish message consisting of a [String] title and [String] body as an
  /// input.
  Future<void> publishExternalNews(int id, String title, String body) async {
    final queryVariables = {
      'id': id,
      'title': title,
      'body': body,
    };
    await (await _graphQLService).mutate(
      ExternalNewsQueries.publishExternalNews,
      variables: queryVariables,
    );
  }

  /// Unpublishes an existing external news.
  ///
  /// Takes the [int] id of the external news to not be published anymore as
  /// an input.
  Future<void> hideExternalNews(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      ExternalNewsQueries.hideExternalNews,
      variables: queryVariables,
    );
  }

  /// Gets the news title from an external news.
  ///
  /// Takes the [ExternalNews] to get the title from as an input.
  /// Returns a [String] representation of the title.
  String getExternalNewsTitle(ExternalNews eN) {
    return eN.title;
  }

  /// Gets the news date from an external news.
  ///
  /// Takes the [ExternalNews] to get the title from as an input.
  /// Returns a [String] representation of the date.
  String getExternalNewsDate(ExternalNews eN) {
    return DateFormat.yMMMMd('de_CH')
        .addPattern('|')
        .add_Hm()
        .format(eN.availableFrom.toLocal());
  }

  /// Returns External News based on a filter
  ///
  /// Takes the [String] name of the external news to be filtered as an input.
  Future<List<ExternalNews>> filterExternalNews(String filter) async {
    final queryVariables = {'filter': filter};
    final data = await (await _graphQLService).query(
      ExternalNewsQueries.filterExternalNews,
      variables: queryVariables,
    );
    final dtoList = data['externalNews'] as List<Object>;
    final externalNewsList = dtoList
        .map((dto) => ExternalNews.fromJson(dto as Map<String, dynamic>))
        .toList();
    return externalNewsList;
  }

  /// Notifies this objects listeners.
  void notifyDataChanged() {
    notifyListeners();
  }
}
