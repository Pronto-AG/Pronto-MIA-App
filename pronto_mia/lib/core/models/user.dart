import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/profiles.dart';

/// The representation of a user, which uses the application.
class User {
  final int id;
  final String userName;
  final Department department;
  final Profile profile;

  /// Initializes a new instance of [User].
  ///
  /// Takes an [int] id, a [String] username, alongside the [Department] the
  /// user works for and a [Profile] set of permissions as an input.
  User({
    this.id,
    this.userName,
    this.department,
    this.profile,
  });

  /// Initializes a new [User] from a JSON format object.
  ///
  /// Takes a [Map] representing a serialized [User] object in JSON-Format as an input.
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        userName = json['userName'] as String,
        department = json['department'] as Map<String, dynamic> != null
            ? Department.fromJson(json['department'] as Map<String, dynamic>)
            : null,
        profile = json['accessControlList'] as Map<String, dynamic> != null
            ? Profile.fromJson(
                json['accessControlList'] as Map<String, dynamic>)
            : null;
}
