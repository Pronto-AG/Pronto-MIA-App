import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pronto_mia/core/models/simple_file.dart';

/// A service, responsible for handling video functionality.
///
/// Contains functionality to download videos and to open videos
class VideoService {
  static const String cacheKey = 'cacheManagerCacheKey';

  final CacheManager _cacheManager;

  /// Initializes a new [VideoService].
  ///
  /// Takes a [CacheManager] as an input or initializes it when the argument is
  /// not given.
  VideoService({CacheManager cacheManager})
      : _cacheManager = cacheManager ??
            CacheManager(
              Config(
                cacheKey,
                stalePeriod: const Duration(days: 7),
                maxNrOfCacheObjects: 20,
              ),
            );

  /// Downloads a video from the provided link
  ///
  /// Takes a [String] link as an input.
  /// Returns the download file as a [SimpleFile];
  Future<SimpleFile> downloadVideo(String path) async {
    final file = await _cacheManager.getSingleFile(path);

    return SimpleFile(name: 'upload.mp4', bytes: file?.readAsBytesSync());
  }
}
