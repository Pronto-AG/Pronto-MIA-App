import 'package:graphql/client.dart';

class ErrorAnalyzer {
  bool _isUnknownError = false;
  bool get isUnknownError => _isUnknownError;
  bool _isNetworkError = false;
  bool get isNetworkError => _isNetworkError;
  bool _isGraphQlError = false;
  bool get isGraphQlError => _isGraphQlError;
  String _graphQLErrorCode;
  String get graphQLErrorCode => _graphQLErrorCode;
  bool _isAuthenticationError = false;
  bool get isAuthenticationError => _isAuthenticationError;

  ErrorAnalyzer({dynamic error}) {
    if (error is OperationException) {
      if (!_isNetworkAvailable(error)) {
        _isNetworkError = true;
        return;
      } else {
        _isGraphQlError = true;
        _checkGraphQLError(error);
        return;
      }
    }

    _isUnknownError = true;
  }

  void _checkGraphQLError(OperationException error) {
    final serverException = error.linkException as ServerException;

    if (serverException.parsedResponse == null ||
        serverException.parsedResponse.errors == null ||
        serverException.parsedResponse.errors.isEmpty ||
        serverException.parsedResponse.errors.length > 1) {
      _isUnknownError = true;
    }

    _graphQLErrorCode = serverException
        .parsedResponse.errors.first.extensions["code"]
        .toString();

    if (_graphQLErrorCode == "AUTH_NOT_AUTHENTICATED") {
      _isAuthenticationError = true;
    }
    if (_graphQLErrorCode == "UnknownError") {
      _isUnknownError = true;
    }
  }

  // ToDo: Replace with #39 globally.
  static bool _isNetworkAvailable(OperationException exception) {
    if (exception.linkException is NetworkException) {
      return false;
    }

    if (exception.linkException is ServerException) {
      final serverException = exception.linkException as ServerException;
      if (serverException.parsedResponse == null) {
        return false;
      }
    }

    return true;
  }
}
