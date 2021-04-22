import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';

class PdfService {
  // TODO: Review cache options
  final _cacheManager = DefaultCacheManager();
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();

  Future<File> downloadPdf(String path) async {
    final token = await (await _jwtTokenService).getToken();
    final httpHeaders = {"Authorization": "Bearer $token"};

    final file = await _cacheManager.getSingleFile(path, headers: httpHeaders);
    return file;
  }
}
