import 'dart:typed_data';

class SimpleFile {
  String get name => _name;
  final String _name;

  Uint8List get bytes => _bytes;
  final Uint8List _bytes;

  SimpleFile(this._name, this._bytes);
}
