import 'package:global_configuration/global_configuration.dart';
import 'package:mockito/mockito.dart';

class MockGlobalConfiguration extends Mock implements GlobalConfiguration {
  @override
  Map<String, dynamic> appConfig;

  @override
  void add(Map<String, dynamic> map) {}

  @override
  void addValue(String key, dynamic value) {}

  @override
  void clear() {}

  @override
  dynamic get(String key) {
    return null;
  }

  @override
  bool getBool(String key) {
    return null;
  }

  @override
  T getDeepValue<T>(String keyPath) {
    return null;
  }

  @override
  double getDouble(String key) {
    return null;
  }

  @override
  int getInt(String key) {
    return null;
  }

  @override
  String getString(String key) {
    return null;
  }

  @override
  T getValue<T>(String key) {
    return null;
  }

  @override
  Future<GlobalConfiguration> loadFromAsset(String name) {
    return Future.value();
  }

  @override
  GlobalConfiguration loadFromMap(Map<String, dynamic> map) {
    return null;
  }

  @override
  Future<GlobalConfiguration> loadFromPath(String path) {
    return Future.value();
  }

  @override
  Future<GlobalConfiguration> loadFromPathIntoKey(String path, String key) {
    return Future.value();
  }

  @override
  Future<GlobalConfiguration> loadFromUrl(
    String url,
    {Map<String, String> queryParameters, Map<String, String> headers}) {
    return Future.value();
  }

  @override
  Future<GlobalConfiguration> loadFromUrlIntoKey(
    String url,
    String key,
    {Map<String, String> queryParameters, Map<String, String> headers}) {
    return Future.value();
  }

  @override
  void setValue(dynamic key, dynamic value) {}

  @override
  void updateValue(String key, dynamic value) {}
}