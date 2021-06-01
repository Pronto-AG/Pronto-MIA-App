import 'package:pronto_mia/core/models/access_control_list.dart';

class Profile {
  final String description;
  final AccessControlList accessControlList;

  const Profile({this.description, this.accessControlList});
}

class Profiles {
  static const Profile administrator = Profile(
    description: 'Administrator',
    accessControlList: AccessControlList(
      canViewDeploymentPlans: true,
      canEditDeploymentPlans: true,
      canViewUsers: true,
      canEditUsers: true,
      canViewDepartments: true,
      canEditDepartments: true,
    ),
  );
}
