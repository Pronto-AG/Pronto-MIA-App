import 'package:pronto_mia/core/factories/analyzed_error_factory.dart';

/// A representation of an error analyzed through [AnalyzedErrorFactory].
///
/// It contains properties showing different attributes the error has.
class AnalyzedError {
  bool isUnknownError = false;
  bool isNetworkError = false;
  bool isCacheError = false;
  bool isGraphQlError = false;
  bool isPasswordError = false;
  bool isAuthenticationError = false;
  String graphQLErrorCode;
  String passwordErrorClarification;
  dynamic error;
}

/// An immutable representation of [AnalyzedError].
class ConstAnalyzedError {
  bool _isUnknownError = false;
  bool get isUnknownError => _isUnknownError;
  bool _isNetworkError = false;
  bool get isNetworkError => _isNetworkError;
  bool _isCacheError = false;
  bool get isCacheError => _isCacheError;
  bool _isGraphQlError = false;
  bool get isGraphQlError => _isGraphQlError;
  bool _isPasswordError = false;
  bool get isPasswordError => _isPasswordError;
  bool _isAuthenticationError = false;
  bool get isAuthenticationError => _isAuthenticationError;
  String _graphQLErrorCode;
  String get graphQLErrorCode => _graphQLErrorCode;
  String _passwordErrorClarification;
  String get passwordErrorClarification => _passwordErrorClarification;
  dynamic _error;
  dynamic get error => _error;

  /// Initializes a new instance of [ConstAnalyzedError].
  ///
  /// Takes different [bool] and [String] error properties, including the
  /// original error as an input.
  ConstAnalyzedError(AnalyzedError error) {
    _isUnknownError = error.isUnknownError;
    _isNetworkError = error.isNetworkError;
    _isCacheError = error.isCacheError;
    _isGraphQlError = error.isGraphQlError;
    _isPasswordError = error.isPasswordError;
    _graphQLErrorCode = error.graphQLErrorCode;
    _passwordErrorClarification = error.passwordErrorClarification;
    _isAuthenticationError = error.isAuthenticationError;
    _error = error.error;
  }
}
