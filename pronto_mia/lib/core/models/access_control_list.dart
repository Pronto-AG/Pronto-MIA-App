/// The representation of an access control list, containing all permissions a
/// user can have.
class AccessControlList {
  final int id;
  bool canViewDeploymentPlans;
  bool canViewDepartmentDeploymentPlans;
  bool canEditDeploymentPlans;
  bool canEditDepartmentDeploymentPlans;
  bool canViewUsers;
  bool canViewDepartmentUsers;
  bool canEditUsers;
  bool canEditDepartmentUsers;
  bool canViewDepartments;
  bool canViewOwnDepartment;
  bool canEditDepartments;
  bool canEditOwnDepartment;
  bool canEditExternalNews;
  bool canViewInternalNews;
  bool canEditInternalNews;
  bool canViewEducationalContent;
  bool canEditEducationalContent;
  bool canViewAppointment;
  bool canEditAppointment;

  /// Initializes a new instance of [AccessControlList].
  ///
  /// Takes an [int] id and [bool] permission options as an input.
  AccessControlList({
    this.id,
    this.canViewDeploymentPlans = false,
    this.canViewDepartmentDeploymentPlans = false,
    this.canEditDeploymentPlans = false,
    this.canEditDepartmentDeploymentPlans = false,
    this.canViewUsers = false,
    this.canViewDepartmentUsers = false,
    this.canEditUsers = false,
    this.canEditDepartmentUsers = false,
    this.canViewDepartments = false,
    this.canViewOwnDepartment = false,
    this.canEditDepartments = false,
    this.canEditOwnDepartment = false,
    this.canEditExternalNews = false,
    this.canViewInternalNews = false,
    this.canEditInternalNews = false,
    this.canViewEducationalContent = false,
    this.canEditEducationalContent = false,
    this.canViewAppointment = false,
    this.canEditAppointment = false,
  });

  /// Initializes a new [AccessControlList] from the values of another.
  ///
  /// Takes the [AccessControlList] to copy as an input.
  AccessControlList.copy(AccessControlList toCopy)
      : id = toCopy.id,
        canViewDeploymentPlans = toCopy.canViewDeploymentPlans,
        canViewDepartmentDeploymentPlans =
            toCopy.canViewDepartmentDeploymentPlans,
        canEditDeploymentPlans = toCopy.canEditDeploymentPlans,
        canEditDepartmentDeploymentPlans =
            toCopy.canEditDepartmentDeploymentPlans,
        canViewUsers = toCopy.canViewUsers,
        canViewDepartmentUsers = toCopy.canViewDepartmentUsers,
        canEditUsers = toCopy.canEditUsers,
        canEditDepartmentUsers = toCopy.canEditDepartmentUsers,
        canViewDepartments = toCopy.canViewDepartments,
        canViewOwnDepartment = toCopy.canViewOwnDepartment,
        canEditDepartments = toCopy.canEditDepartments,
        canEditOwnDepartment = toCopy.canEditOwnDepartment,
        canEditExternalNews = toCopy.canEditExternalNews,
        canViewInternalNews = toCopy.canViewInternalNews,
        canEditInternalNews = toCopy.canEditInternalNews,
        canViewEducationalContent = toCopy.canViewEducationalContent,
        canEditEducationalContent = toCopy.canEditEducationalContent,
        canViewAppointment = toCopy.canViewAppointment,
        canEditAppointment = toCopy.canEditAppointment;

  /// Initializes a new [AccessControlList] from a JSON format object.
  ///
  /// Takes a [Map] representing a serialized [AccessControlList] object in
  /// JSON-Format as an input.
  AccessControlList.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        canViewDeploymentPlans =
            json['canViewDeploymentPlans'] as bool ?? false,
        canViewDepartmentDeploymentPlans =
            json['canViewDepartmentDeploymentPlans'] as bool ?? false,
        canEditDeploymentPlans =
            json['canEditDeploymentPlans'] as bool ?? false,
        canEditDepartmentDeploymentPlans =
            json['canEditDepartmentDeploymentPlans'] as bool ?? false,
        canViewUsers = json['canViewUsers'] as bool ?? false,
        canViewDepartmentUsers =
            json['canViewDepartmentUsers'] as bool ?? false,
        canEditUsers = json['canEditUsers'] as bool ?? false,
        canEditDepartmentUsers =
            json['canEditDepartmentUsers'] as bool ?? false,
        canViewDepartments = json['canViewDepartments'] as bool ?? false,
        canViewOwnDepartment = json['canViewOwnDepartment'] as bool ?? false,
        canEditDepartments = json['canEditDepartments'] as bool ?? false,
        canEditOwnDepartment = json['canEditOwnDepartment'] as bool ?? false,
        canEditExternalNews = json['canEditExternalNews'] as bool ?? false,
        canViewInternalNews = json['canViewInternalNews'] as bool ?? false,
        canEditInternalNews = json['canEditInternalNews'] as bool ?? false,
        canViewEducationalContent =
            json['canViewEducationalContent'] as bool ?? false,
        canEditEducationalContent =
            json['canEditEducationalContent'] as bool ?? false,
        canViewAppointment = json['canViewAppointment'] as bool ?? false,
        canEditAppointment = json['canEditAppointment'] as bool ?? false;

  /// Converts an [AccessControlList] to a JSON format object.
  ///
  /// Returns the current instances values as a [Map] JSON object
  /// representation.
  Map<String, dynamic> toJson() {
    return {
      'canViewDeploymentPlans': canViewDeploymentPlans,
      'canViewDepartmentDeploymentPlans': canViewDepartmentDeploymentPlans,
      'canEditDeploymentPlans': canEditDeploymentPlans,
      'canEditDepartmentDeploymentPlans': canEditDepartmentDeploymentPlans,
      'canViewUsers': canViewUsers,
      'canViewDepartmentUsers': canViewDepartmentUsers,
      'canEditUsers': canEditUsers,
      'canEditDepartmentUsers': canEditDepartmentUsers,
      'canViewDepartments': canViewDepartments,
      'canViewOwnDepartment': canViewOwnDepartment,
      'canEditDepartments': canEditDepartments,
      'canEditOwnDepartment': canEditOwnDepartment,
      'canEditExternalNews': canEditExternalNews,
      'canViewInternalNews': canViewInternalNews,
      'canEditInternalNews': canEditInternalNews,
      'canViewEducationalContent': canViewEducationalContent,
      'canEditEducationalContent': canEditEducationalContent,
      'canViewAppointment': canViewAppointment,
      'canEditAppointment': canEditAppointment,
    };
  }

  /// Determines if the current instances values are equal to another
  /// [AccessControlList].
  ///
  /// Takes the [AccessControlList] to compare as an input.
  /// Returns wether the compared values are equal as [bool].
  bool isEqual(AccessControlList other) {
    if (canViewDeploymentPlans == other.canViewDeploymentPlans &&
        canViewDepartmentDeploymentPlans ==
            other.canViewDepartmentDeploymentPlans &&
        canEditDeploymentPlans == other.canEditDeploymentPlans &&
        canEditDepartmentDeploymentPlans ==
            other.canEditDepartmentDeploymentPlans &&
        canViewUsers == other.canViewUsers &&
        canViewDepartmentUsers == other.canViewDepartmentUsers &&
        canEditUsers == other.canEditUsers &&
        canEditDepartmentUsers == other.canEditDepartmentUsers &&
        canViewDepartments == other.canViewDepartments &&
        canViewOwnDepartment == other.canViewOwnDepartment &&
        canEditDepartments == other.canEditDepartments &&
        canEditOwnDepartment == other.canEditOwnDepartment &&
        canEditExternalNews == other.canEditExternalNews &&
        canViewInternalNews == other.canViewInternalNews &&
        canEditInternalNews == other.canEditInternalNews &&
        canViewEducationalContent == other.canViewEducationalContent &&
        canEditEducationalContent == other.canEditEducationalContent &&
        canViewAppointment == other.canViewAppointment &&
        canEditAppointment == other.canEditAppointment) {
      return true;
    } else {
      return false;
    }
  }
}
