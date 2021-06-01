class AccessControlList {
  final int id;
  final bool canViewDeploymentPlans;
  final bool canEditDeploymentPlans;
  final bool canViewUsers;
  final bool canEditUsers;
  final bool canViewDepartments;
  final bool canEditDepartments;

  const AccessControlList({
    this.id,
    this.canViewDeploymentPlans,
    this.canEditDeploymentPlans,
    this.canViewUsers,
    this.canEditUsers,
    this.canViewDepartments,
    this.canEditDepartments,
  });

  AccessControlList.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        canViewDeploymentPlans = json['canViewDeploymentPlans'] as bool,
        canEditDeploymentPlans = json['canEditDeploymentPlans'] as bool,
        canViewUsers = json['canViewUsers'] as bool,
        canEditUsers = json['canEditUsers'] as bool,
        canViewDepartments = json['canViewDepartments'] as bool,
        canEditDepartments = json['canEditDepartments'] as bool;
}
