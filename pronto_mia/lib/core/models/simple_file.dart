import 'dart:typed_data';

/// The representation of a file, not bound by a platform.
///
/// Unifies the different file representations available on different platforms
/// by only allowing minimal information to be set.
class SimpleFile {
  final String name;
  final Uint8List bytes;

  /// Initializes a new instance of [SimpleFile].
  ///
  /// Takes a [String] file name and file content in the form of a [Uint8List]
  /// list of bytes as an input.
  SimpleFile({this.name, this.bytes});
}
