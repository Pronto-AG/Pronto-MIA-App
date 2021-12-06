import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/educational_content_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

/// A service, responsible for accessing educational content.
///
/// Contains methods to modify and access educational content information.
class EducationalContentService with ChangeNotifier {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  /// Gets the list of all educational content.
  ///
  /// Returns a [List] list of educational content.
  Future<List<EducationalContent>> getEducationalContent() async {
    final data = await (await _graphQLService).query(
      EducationalContentQueries.educationalContent,
    );

    final dtoList = data['educationalContent'] as List<Object>;
    final educationalContentList = dtoList
        .map((dto) => EducationalContent.fromJson(dto as Map<String, dynamic>))
        .toList();

    return educationalContentList;
  }

  /// Gets the list of all currently available educational content.
  ///
  /// Returns a [List] list of educational content.
  /// Currently available educational content include all educational content,
  /// which have an end date still in the future.
  Future<List<EducationalContent>> getAvailableEducationalContent() async {
    final data = await (await _graphQLService).query(
      EducationalContentQueries.educationalContentAvailable,
    );

    final dtoList = data['educationalContent'] as List<Object>;
    final educationalContentList = dtoList
        .map((dto) => EducationalContent.fromJson(dto as Map<String, dynamic>))
        .toList();

    return educationalContentList;
  }

  /// Gets an educational content.
  ///
  /// Returns a [EducationalContent].
  Future<EducationalContent> getEducationalContentById(int id) async {
    final Map<String, dynamic> queryVariables = {
      'id': id,
    };

    final data = await (await _graphQLService).query(
      EducationalContentQueries.educationalContentById,
      variables: queryVariables,
    );

    final dtoList = data['educationalContent'] as List<Object>;
    final educationalContent = dtoList
        .map((dto) => EducationalContent.fromJson(dto as Map<String, dynamic>))
        .first;

    return educationalContent;
  }

  /// Gets the video of an educational content.
  ///
  /// Returns a [Video] of an educational content.
  Future<void> getEducationalContentVideo(
    EducationalContent educationalContent,
  ) async {
    return;
  }

  /// Creates a new educational content.
  ///
  /// Takes different attributes of an educational content as an input.
  Future<void> createEducationalContent(
    String title,
    String description,
    SimpleFile videoFile,
  ) async {
    final Map<String, dynamic> queryVariables = {
      'title': title,
      'description': description,
    };

    queryVariables['file'] = http.MultipartFile.fromBytes(
      'file',
      videoFile.bytes,
      filename: videoFile.name,
      contentType: MediaType('video', 'mp4'),
    );

    await (await _graphQLService).mutate(
      EducationalContentQueries.createEducationalContent,
      variables: queryVariables,
    );
  }

  /// Updates an existing educational content.
  ///
  /// Takes different attributes of the educational content
  /// to be updated as an input.
  Future<void> updateEducationalContent(
    int id,
    String title,
    String description,
    SimpleFile video,
  ) async {
    final Map<String, dynamic> queryVariables = {
      'id': id,
      'title': title,
      'description': description,
    };

    if (video != null) {
      queryVariables['file'] = http.MultipartFile.fromBytes(
        'video',
        video.bytes,
        filename: video.name,
        contentType: MediaType('video', 'mp4'),
      );
    }

    await (await _graphQLService).mutate(
      EducationalContentQueries.updateEducationalContent,
      variables: queryVariables,
    );
  }

  /// Removes an existing educational content.
  ///
  /// Takes the [int] id of the educational content to be removed as an input.
  Future<void> removeEducationalContent(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      EducationalContentQueries.removeEducationalContent,
      variables: queryVariables,
    );
  }

  /// Publishes an existing educational content.
  ///
  /// Takes the [int] id of the educational content to be published, alongside a
  /// publish message consisting of a [String] title and [String] body as an
  /// input.
  Future<void> publishEducationalContent(
    int id,
    String title,
    String body,
  ) async {
    final queryVariables = {
      'id': id,
      'title': title,
      'body': body,
    };
    await (await _graphQLService).mutate(
      EducationalContentQueries.publishEducationalContent,
      variables: queryVariables,
    );
  }

  /// Unpublishes an existing educational content.
  ///
  /// Takes the [int] id of the educational content to not be
  /// published anymore as an input.
  Future<void> hideEducationalContent(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      EducationalContentQueries.hideEducationalContent,
      variables: queryVariables,
    );
  }

  /// Gets the news title from an educational content.
  ///
  /// Takes the [EducationalContent] to get the title from as an input.
  /// Returns a [String] representation of the title.
  String getEducationalContentTitle(EducationalContent educationalContent) {
    return educationalContent.title;
  }

  /// Returns educational content based on a filter
  ///
  /// Takes the [String] name of the educational content
  /// to be filtered as an input.
  Future<List<EducationalContent>> filterEducationalContent(
    String filter,
  ) async {
    final queryVariables = {'filter': filter};
    final data = await (await _graphQLService).query(
      EducationalContentQueries.filterEducationalContent,
      variables: queryVariables,
    );
    final dtoList = data['educationalContent'] as List<Object>;
    final educationalContentList = dtoList
        .map((dto) => EducationalContent.fromJson(dto as Map<String, dynamic>))
        .toList();
    return educationalContentList;
  }

  /// Opens a view, containing [EducationalContent].
  ///
  /// Takes a [EducationalContent].
  Future<void> openEducationalContent(
    EducationalContent educationalContent,
  ) async {
    return;
  }

  /// Notifies this objects listeners.
  void notifyDataChanged() {
    notifyListeners();
  }
}
