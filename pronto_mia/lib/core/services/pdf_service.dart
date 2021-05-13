import 'package:universal_html/html.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfService {
  static const String cacheKey = 'cacheManagerCacheKey';

  final _cacheManager = CacheManager(
    Config(
      cacheKey,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
    ),
  );
  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();

  Future<SimpleFile> downloadPdf(String path) async {
    final token = await (await _jwtTokenService).getToken();
    final httpHeaders = {"Authorization": "Bearer $token"};
    final file = await _cacheManager.getSingleFile(path, headers: httpHeaders);

    return SimpleFile(name: 'upload.pdf', bytes: file.readAsBytesSync());
  }

  void openPdfWeb(SimpleFile pdf) {
    final blob = Blob([pdf.bytes], 'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    launch(url);
  }
}
