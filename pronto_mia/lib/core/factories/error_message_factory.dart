import 'package:pronto_mia/core/models/analyzed_error.dart';

/// A factory, that is responsible for determining the corresponding error
/// message from an [AnalyzedError].
///
/// Currently only available in German.
// ignore_for_file: avoid_classes_with_only_static_members
class ErrorMessageFactory {
  static const String _unknownError =
      'Es ist ein unerwarteter Fehler aufgetreten.';
  static const String _networkError =
      'Es konnte keine Verbindung zum Server aufgebaut werden.';

  /// Determines error message as [String] for an [ConstAnalyzedError] from
  /// [AnalyzedErrorFactory].
  ///
  /// Takes an [AnalyzedError] as input.
  /// Returns the corresponding error message as [String].
  static String getErrorMessage(ConstAnalyzedError analyzedError) {
    if (analyzedError.graphQLErrorCode != null) {
      if (analyzedError.isPasswordError == true &&
          analyzedError.graphQLErrorCode == "PasswordTooWeak") {
        return _getPasswordErrorMessage(
          analyzedError.passwordErrorClarification,
        );
      }

      return _getGraphQlErrorMessage(analyzedError.graphQLErrorCode);
    }
    if (analyzedError.isNetworkError) {
      return _networkError;
    }

    return _unknownError;
  }

  static String _getGraphQlErrorMessage(String code) {
    switch (code) {
      case 'UserAlreadyExists':
        return 'Ein Benutzer mit diesem Benutzernamen existiert bereits.';
        break;
      case 'UserNotFound':
        return 'Der angegebene Benutzer existiert nicht.';
        break;
      case 'DepartmentAlreadyExists':
        return 'Eine Abteilung mit diesem Namen existiert bereits.';
        break;
      case 'DepartmentNotFound':
        return "Die angegebene Abteilung konnte nicht gefunden werden.";
        break;
      case 'DepartmentInUse':
        return "Abteilung kann nicht gelöscht werden, da ihr noch "
            "Benutzer zugewiesen sind.";
        break;
      case 'ExternalNewsNotFound':
        return 'Der angegebene News Eintrag existiert nicht.';
        break;
      case 'InternalNewsNotFound':
        return 'Der angegebene Aktuelles Eintrag existiert nicht.';
        break;
      case 'EducationalContentNotFound':
        return 'Der angegebene Schulungsvideo Eintrag existiert nicht.';
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
      default:
        return _unknownError;
    }
  }

  static String _getPasswordErrorMessage(String passwordErrorClarification) {
    String message =
        'Das neue Passwort entspricht nicht den Passwort-Richtlinien. Es muss '
        'mindestens 10 Zeichen lang sein, eine Zahl, einen Grossbuchstaben, '
        'einen Kleinbuchstaben und ein Sonderzeichen enthalten.\n - Problem: ';
    switch (passwordErrorClarification) {
      case "Length":
        message += "Das Passwort ist zu kurz.";
        break;
      case "NonAlphanumeric":
        message += "Das Passwort enthält kein Sonderzeichen.";
        break;
      case "Uppercase":
        message += "Das Passwort enthält keinen Grossbuchstaben.";
        break;
      case "Lowercase":
        message += "Das Passwort enthält keinen Kleinbuchstaben.";
        break;
      case "Digit":
        message += "Das Passwort enthält keine Zahl.";
        break;
      default:
        message += "Unbekannt.";
    }

    return message;
  }
}
