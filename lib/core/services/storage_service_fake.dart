import 'storage_service.dart';

/// Provides storage interaction with the counter.
class StorageServiceFake extends StorageService {
  /// Retrieves current counter.
  ///
  /// Returns the value of the current counter as a Future int.
  /// ```dart
  /// getCounterValue() == 11
  /// ```
  @override
  Future<int> getCounterValue() async {
    return 11;
  }

  /// Saves [value] as new counter.
  ///
  /// Takes [value] as an input for the new counter and returns a Future void.
  /// ```dart
  /// saveCounterValue(5) == void
  /// ```
  @override
  Future<void> saveCounterValue(int value) async {}
}
