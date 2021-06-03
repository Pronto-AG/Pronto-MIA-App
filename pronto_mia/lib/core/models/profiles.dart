import 'package:pronto_mia/core/models/access_control_list.dart';

class Profile {
  final String description;
  final AccessControlList accessControlList;

  const Profile({this.description, this.accessControlList});

  Profile.fromJson(Map<String, dynamic> json)
      : description = profiles.entries
            .firstWhere(
              (entry) => entry.value.accessControlList
                  .isEqual(AccessControlList.fromJson(json)),
              orElse: () => const MapEntry(
                  'custom', Profile(description: 'Benutzerdefiniert')),
            )
            .value
            .description,
        accessControlList = AccessControlList.fromJson(json);
}

final profiles = {
  'empty': Profile(
    description: 'Leer',
    accessControlList: AccessControlList(),
  ),
  'cleaner': Profile(
    description: 'Reinigungskraft',
    accessControlList: AccessControlList(
      canViewDeploymentPlans: true,
    ),
  ),
  'administrator': Profile(
    description: 'Administrator',
    accessControlList: AccessControlList(
      canViewDeploymentPlans: true,
      canEditDeploymentPlans: true,
      canViewUsers: true,
      canEditUsers: true,
      canViewDepartments: true,
      canEditDepartments: true,
    ),
  ),
};
