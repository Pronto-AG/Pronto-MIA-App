/// A representation of a department a [User] works for.
class Department {
  final int id;
  final String name;

  /// Initializes a new instance of [Department].
  ///
  /// Takes an [int] id and the [String] department name as an input.
  Department({this.id, this.name});

  /// Initializes a new [Department] from a JSON format object.
  ///
  /// Takes a [Map] representing a JSON object as an input.
  Department.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String;
}
