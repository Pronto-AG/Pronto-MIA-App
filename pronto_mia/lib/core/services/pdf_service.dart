import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/queries/upload_pdf.dart';
import 'package:pronto_mia/core/queries/deployment_plans.dart';

class PdfService {
  final _graphQLService = locator<GraphQLService>();
  final _cacheManager = DefaultCacheManager();

  Future<QueryResult> _getPdfPath() async {
    final options =
        QueryOptions(document: gql(DeploymentPlans.deploymentPlans));
    return _graphQLService.query(options);
  }

  Future<QueryResult> uploadPdf(String fileName, Uint8List bytes) async {
    final multiPartFile = MultipartFile.fromBytes(
      'upload',
      bytes,
      filename: fileName,
      contentType: MediaType("application", "pdf"),
    );

    final options = MutationOptions(
      document: gql(UploadPdf.uploadPdf),
      variables: {
        "file": multiPartFile,
        "availableFrom": DateTime.now().toIso8601String(),
        "availableUntil": DateTime.now().toIso8601String(),
      },
    );

    return _graphQLService.mutate(options);
  }

  Future<File> downloadPdf() async {
    final queryResult = await _getPdfPath();
    if (queryResult.hasException) {
      throw queryResult.exception;
    }

    final pdfPath = queryResult.data['deploymentPlans'][0]['link'] as String;
    return _cacheManager.getSingleFile(pdfPath);
  }
}
