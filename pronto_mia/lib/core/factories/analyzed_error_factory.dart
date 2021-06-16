import 'package:graphql/client.dart';
import 'package:pronto_mia/core/models/analyzed_error.dart';

/// A factory, that is globally responsible for analyzing errors.
// ignore: avoid_classes_with_only_static_members
class AnalyzedErrorFactory {
  /// Creates a [ConstAnalyzedError] from an error of any type.
  ///
  /// Takes an error of [dynamic] type as an input.
  /// Returns the [ConstAnalyzedError] representation of the error.
  static ConstAnalyzedError create(dynamic error) {
    final analyzedError = AnalyzedError();
    analyzedError.error = error;
    if (error is OperationException) {
      if (!_isNetworkAvailable(error)) {
        analyzedError.isNetworkError = true;
        return ConstAnalyzedError(analyzedError);
      } else if (_isCachedException(error)) {
        analyzedError.isCacheError = true;
        return ConstAnalyzedError(analyzedError);
      } else {
        analyzedError.isGraphQlError = true;
        _checkGraphQLError(analyzedError, error);
        return ConstAnalyzedError(analyzedError);
      }
    }

    analyzedError.isUnknownError = true;
    return ConstAnalyzedError(analyzedError);
  }

  static void _checkGraphQLError(
      AnalyzedError analyzedError, OperationException error) {
    final serverException = error.linkException as ServerException;

    if (serverException != null &&
        serverException.parsedResponse != null &&
        serverException.parsedResponse.errors != null &&
        serverException.parsedResponse.errors.isNotEmpty &&
        serverException.parsedResponse.errors.length == 1) {
      analyzedError.graphQLErrorCode = serverException
          .parsedResponse.errors.first.extensions["code"]
          .toString();

      if (analyzedError.graphQLErrorCode == "PasswordTooWeak") {
        analyzedError.isPasswordError = true;
        analyzedError.passwordErrorClarification = serverException
            .parsedResponse.errors.first.extensions["passwordPolicyViolation"]
            .toString();
      }
    } else if (error.graphqlErrors != null &&
        error.graphqlErrors.isNotEmpty &&
        error.graphqlErrors.length == 1) {
      analyzedError.graphQLErrorCode =
          error.graphqlErrors.first.extensions["code"].toString();

      if (analyzedError.graphQLErrorCode == "PasswordTooWeak") {
        analyzedError.isPasswordError = true;
        analyzedError.passwordErrorClarification = error
            .graphqlErrors.first.extensions["passwordPolicyViolation"]
            .toString();
      }
    } else {
      analyzedError.isUnknownError = true;
      return;
    }

    if (analyzedError.graphQLErrorCode == "AUTH_NOT_AUTHENTICATED") {
      analyzedError.isAuthenticationError = true;
    }
    if (analyzedError.graphQLErrorCode == "UnknownError") {
      analyzedError.isUnknownError = true;
    }
  }

  // TODO: Replace with Issue #39 globally.
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

  static bool _isCachedException(OperationException exception) {
    if (exception.linkException is CacheMissException) {
      return true;
    }

    return false;
  }
}
