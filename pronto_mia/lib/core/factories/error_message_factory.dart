import 'package:pronto_mia/core/models/error_analyzer.dart';

// ignore: avoid_classes_with_only_static_members
class ErrorMessageFactory {
  static const String _unknownError =
      'Es ist ein unerwarteter Fehler aufgetreten.';
  static const String _networkError =
      'Es konnte keine Verbindung zum Server aufgebaut werden.';

  static String getErrorMessage(ErrorAnalyzer analyzer) {
    if (analyzer.isUnknownError) {
      return _unknownError;
    } else if (analyzer.isNetworkError) {
      return _networkError;
    } else {
      return _getGraphQlErrorMessage(analyzer.graphQLErrorCode);
    }
  }

  static String _getGraphQlErrorMessage(String code) {
    switch (code) {
      case 'PasswordTooWeak':
        return 'Das angegebene Passwort ist zu schwach.';
        break;
      case 'UserAlreadyExists':
        return 'Ein Benutzer mit diesem Benutzernamen existiert bereits.';
        break;
      case 'UserNotFound':
        return 'Der angegebene Benutzer existiert nicht.';
        break;
      case 'DeploymentPlanNotFound':
        return 'Der angegebene Einsatzplan existiert nicht.';
        break;
      case 'DeploymentPlanImpossibleTime':
        return 'Die im Einsatzplan angegebenen Zeiten sind inkorrekt.';
        break;
      case 'WrongPassword':
        return 'Das angegeben Passwort für den Benutzer ist falsch.';
        break;
      case 'IllegalUserOperation':
        return 'Du hast keine Berechtigung diese Aktion auszuführen.';
        break;
      case 'DatabaseOperationError':
        return 'Ein Datenbankfehler ist aufgetreten. '
            'Bitte wende dich an den Administrator der Anwendung.';
        break;
      case 'FileOperationError':
        return 'Ein Dateisystemfehler ist aufgetreten. '
            'Bitte wende dich an den Administrator der Anwendung.';
        break;
      case 'FirebaseOperationError':
        return 'Ein Fehler mit Firebase ist aufgetreten. '
            'Bitte wende dich an den Administrator der Anwendung.';
        break;
      case 'AUTH_NOT_AUTHENTICATED':
        return 'Der Benutzer ist nicht mehr angemeldet.';
        break;
      case 'UnknownError':
        return _unknownError;
        break;
      default:
        return _unknownError;
    }
  }
}
