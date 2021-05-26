AccessControlList {
  final int id;
  final bool canViewDeploymentPlans;
  final bool canEditDeploymentPlans;
  final bool canViewUsers;
  final bool can EditUsers;

  AccessControlList({
    @required this.id,
    @required this.canViewDeploymentPlans,
    @required this.canEditDeploymentPlans,
    @required this.canViewUsers,
    @required this.canEditUsers,
  });

  AccessControlList.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        canViewDeploymentPlans = json['canViewDeploymentPlans'] as bool,
        canEditDeploymentPlans = json['canEditDeploymentPlans'] as bool,
        canViewUsers = json['canViewUsers'] as bool,
        canEditUsers = json['canEditUsers'] as bool;
}