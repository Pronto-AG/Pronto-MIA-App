class ErrorMessageFactory {
  String getErrorMessage(Exception exception) {
    return exception.toString();
  }
}