class AccessControlList {
  final int id;
  bool canViewDeploymentPlans;
  bool canEditDeploymentPlans;
  bool canViewUsers;
  bool canEditUsers;
  bool canViewDepartments;
  bool canEditDepartments;

  AccessControlList({
    this.id,
    this.canViewDeploymentPlans = false,
    this.canEditDeploymentPlans = false,
    this.canViewUsers = false,
    this.canEditUsers = false,
    this.canViewDepartments = false,
    this.canEditDepartments = false,
  });

  AccessControlList.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        canViewDeploymentPlans =
            json['canViewDeploymentPlans'] as bool ?? false,
        canEditDeploymentPlans =
            json['canEditDeploymentPlans'] as bool ?? false,
        canViewUsers = json['canViewUsers'] as bool ?? false,
        canEditUsers = json['canEditUsers'] as bool ?? false,
        canViewDepartments = json['canViewDepartments'] as bool ?? false,
        canEditDepartments = json['canEditDepartments'] as bool ?? false;

  Map<String, dynamic> toJson() {
    return {
      'canViewDeploymentPlans': canViewDeploymentPlans,
      'canEditDeploymentPlans': canEditDeploymentPlans,
      'canViewDepartments': canViewDepartments,
      'canEditDepartments': canEditDepartments,
      'canViewUsers': canViewUsers,
      'canEditUsers': canEditUsers,
    };
  }

  bool isEqual(AccessControlList other) {
    if (canViewDeploymentPlans == other.canViewDeploymentPlans &&
        canEditDeploymentPlans == other.canEditDeploymentPlans &&
        canViewDepartments == other.canViewDepartments &&
        canEditDepartments == other.canEditDepartments &&
        canViewUsers == other.canViewUsers &&
        canEditUsers == other.canEditUsers) {
      return true;
    } else {
      return false;
    }
  }
}
