class ErrorMessageFactory {
  String getErrorMessage(dynamic error) {
    // ignore: avoid_print
    print(error);
    return 'Es ist ein unerwarteter Fehler aufgetreten.';
  }
}