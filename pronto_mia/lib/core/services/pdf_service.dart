import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/queries/upload_pdf.dart';
import 'package:pronto_mia/core/queries/deployment_plans.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';

class PdfService {
  final _cacheManager = DefaultCacheManager();
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();

  Future<void> uploadPdf(String fileName, Uint8List bytes) async {
    final multiPartFile = MultipartFile.fromBytes(
      'upload',
      bytes,
      filename: fileName,
      contentType: MediaType("application", "pdf"),
    );

    final queryVariables = {
      "file": multiPartFile,
      "availableFrom": DateTime.now().toIso8601String(),
      "availableUntil": DateTime.now().toIso8601String(),
    };

    final result = await (await _graphQLService).mutate(
        UploadPdf.uploadPdf, queryVariables);
    print(result);
  }

  Future<File> downloadPdf(String path) async {
    final token = await (await _jwtTokenService).getToken();
    final httpHeaders = {"Authorization": "Bearer $token"};

    final file = await _cacheManager.getSingleFile(path, headers: httpHeaders);
    return file;
  }
}
