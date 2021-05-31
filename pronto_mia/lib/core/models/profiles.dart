import 'package:pronto_mia/core/models/access_control_list.dart';

class Profile {
  final String description;
  final AccessControlList accessControlList;

  const Profile({this.description, this.accessControlList});
}

// ignore: avoid_classes_with_only_static_members
class Profiles {
  static Profile empty = Profile(
    description: 'Leer',
    accessControlList: AccessControlList(),
  );

  static Profile administrator = Profile(
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

  static Profile cleaner = Profile(
    description: 'Reinigungskraft',
    accessControlList: AccessControlList(
      canViewDeploymentPlans: true,
      canEditDeploymentPlans: false,
      canViewUsers: false,
      canEditUsers: false,
      canViewDepartments: false,
      canEditDepartments: false,
    ),
  );
}
