import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/profiles.dart';

class User {
  final int id;
  final String userName;
  final Department department;
  final Profile profile;

  User({
    this.id,
    this.userName,
    this.department,
    this.profile,
  });

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
