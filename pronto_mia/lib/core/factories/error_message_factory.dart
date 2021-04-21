// TODO: Implement error distinction
import 'package:flutter/foundation.dart';

class ErrorMessageFactory {
  String getErrorMessage(dynamic error) {
    // ignore: avoid_print
    print(error);
    return 'Es ist ein unerwarteter Fehler aufgetreten.';
  }
}