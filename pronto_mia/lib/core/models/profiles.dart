import 'package:pronto_mia/core/models/access_control_list.dart';

/// The representation of a named set of permissions
///
/// Contains the [AccessControlList], that build the profile description.
class Profile {
  final String description;
  final AccessControlList accessControlList;

  /// Initializes a new instance of [Profile].
  ///
  /// Takes a [String] description and a [AccessControlList] list of permissions
  /// as an input.
  const Profile({this.description, this.accessControlList});

  /// Initializes a new [Profile] from a JSON format object.
  ///
  /// Takes a [Map] representing a serialized [Profile] object in JSON-Format
  /// as an input.
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

/// Contains default profiles, which an [User] can have.
final profiles = {
  'empty': Profile(
    description: 'Leer',
    accessControlList: AccessControlList(
      canViewOwnDepartment: true,
    ),
  ),
  'cleaner': Profile(
    description: 'Reinigungskraft',
    accessControlList: AccessControlList(
      canViewDepartmentDeploymentPlans: true,
      canViewOwnDepartment: true,
    ),
  ),
  'department-manager': Profile(
    description: 'Abteilungsleiter',
    accessControlList: AccessControlList(
      canViewDepartmentDeploymentPlans: true,
      canEditDepartmentDeploymentPlans: true,
      canViewDepartmentUsers: true,
      canEditDepartmentUsers: true,
      canViewDepartments: true,
      canEditOwnDepartment: true,
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
