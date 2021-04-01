import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/queries/upload_pdf.dart';
import 'package:pronto_mia/core/queries/pdf.dart';

class FileService {
  final _graphQLService = locator<GraphQLService>();
  final _cacheManager = DefaultCacheManager();

  Future<QueryResult> uploadFile(MultipartFile file) async {
    final options = MutationOptions(
      document: gql(UploadPdf.uploadPdf),
      variables: {
        "upload": file,
      },
    );

    return _graphQLService.mutate(options);
  }

  Future<File> downloadFile() async {
    final options = QueryOptions(
        document: gql(Pdf.pdf)
    );

    final result = await _graphQLService.query(options);
    return _cacheManager.getSingleFile(
        result.data['pdf']['link'] as String
    );
  }
}