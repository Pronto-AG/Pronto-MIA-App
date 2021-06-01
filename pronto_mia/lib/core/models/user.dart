import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/access_control_list.dart';

class User {
  final int id;
  final String userName;
  final Department department;
  final AccessControlList accessControlList;

  User({
    this.id,
    this.userName,
    this.department,
    this.accessControlList,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        userName = json['userName'] as String,
        department = json['department'] as Map<String, dynamic> != null
            ? Department.fromJson(json['department'] as Map<String, dynamic>)
            : null,
        accessControlList =
            json['accessControlList'] as Map<String, dynamic> != null
                ? AccessControlList.fromJson(
                    json['accessControlList'] as Map<String, dynamic>)
                : null;
}
