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
  });

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
        canEditOwnDepartment = toCopy.canEditOwnDepartment;

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
        canEditOwnDepartment = json['canEditOwnDepartment'] as bool ?? false;

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
    };
  }

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
        canEditOwnDepartment == other.canEditOwnDepartment) {
      return true;
    } else {
      return false;
    }
  }
}
