import 'package:universal_html/html.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:url_launcher/url_launcher.dart';

/// A service, responsible for handling pdf functionality.
///
/// Contains functionality to download pdfs and to open pdfs in new browser
/// tabs.
class PdfService {
  static const String cacheKey = 'cacheManagerCacheKey';

  final CacheManager _cacheManager;

  /// Initializes a new [PdfService].
  ///
  /// Takes a [CacheManager] as an input or initializes it when the argument is
  /// not given.
  PdfService({CacheManager cacheManager})
      : _cacheManager = cacheManager ??
            CacheManager(
              Config(
                cacheKey,
                stalePeriod: const Duration(days: 7),
                maxNrOfCacheObjects: 20,
              ),
            );

  Future<JwtTokenService> get _jwtTokenService =>
      locator.getAsync<JwtTokenService>();

  /// Downloads a pdf from the provided link
  ///
  /// Takes a [String] link as an input.
  /// Returns the download file as a [SimpleFile];
  Future<SimpleFile> downloadPdf(String path) async {
    final token = await (await _jwtTokenService).getToken();
    final httpHeaders = {"Authorization": "Bearer $token"};
    final file = await _cacheManager.getSingleFile(path, headers: httpHeaders);

    return SimpleFile(name: 'upload.pdf', bytes: file?.readAsBytesSync());
  }

  /// Opens a new browser tab with the provided pdf in it.
  ///
  /// Takes a pdf file as [SimpleFile] as an input.
  void openPdfWeb(SimpleFile pdf) {
    final blob = Blob([pdf.bytes], 'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    launch(url);
  }
}
