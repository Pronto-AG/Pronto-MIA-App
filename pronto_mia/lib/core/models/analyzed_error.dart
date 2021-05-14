class AnalyzedError {
  bool isUnknownError = false;
  bool isNetworkError = false;
  bool isCacheError = false;
  bool isGraphQlError = false;
  String graphQLErrorCode;
  bool isAuthenticationError = false;
  dynamic error;
}

class ConstAnalyzedError {
  bool _isUnknownError = false;
  bool get isUnknownError => _isUnknownError;
  bool _isNetworkError = false;
  bool get isNetworkError => _isNetworkError;
  bool _isCacheError = false;
  bool get isCacheError => _isCacheError;
  bool _isGraphQlError = false;
  bool get isGraphQlError => _isGraphQlError;
  String _graphQLErrorCode;
  String get graphQLErrorCode => _graphQLErrorCode;
  bool _isAuthenticationError = false;
  bool get isAuthenticationError => _isAuthenticationError;
  dynamic _error;
  dynamic get error => _error;

  ConstAnalyzedError(AnalyzedError error) {
    _isUnknownError = error.isUnknownError;
    _isNetworkError = error.isNetworkError;
    _isCacheError = error.isCacheError;
    _isGraphQlError = error.isGraphQlError;
    _graphQLErrorCode = error.graphQLErrorCode;
    _isAuthenticationError = error.isAuthenticationError;
    _error = error.error;
  }
}
