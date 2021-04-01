import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart';

import 'package:informbob_app/app/gql_client.dart';
import 'package:informbob_app/core/queries/upload_pdf.dart';
import 'package:informbob_app/core/queries/pdf.dart';

class FileService {
  final GraphQLClient _gqlClient = GqlConfig.client;
  final CacheManager _cacheManager = DefaultCacheManager();

  Future<QueryResult> uploadFile(MultipartFile file) async {
    final options = MutationOptions(
      document: gql(UploadPdf.uploadPdf),
      variables: {
        "upload": file,
      },
    );

    var result = await _gqlClient.mutate(options);
    print(result);

    return result;
  }

  Future<File> downloadFile() async {
    final options = QueryOptions(
      document: gql(Pdf.pdf)
    );

    final result = await _gqlClient.query(options);
    return _cacheManager.getSingleFile(
      result.data['pdf']['link'] as String
    );
  }
}