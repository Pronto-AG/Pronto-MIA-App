class UserQueries {
  static const users = """
    query users() {
      users {
        id
        userName
        accessControlList {
          id
          canEditDeploymentPlans
          canEditUsers
          canViewDeploymentPlans
          canViewUsers
        }
      }
    }
  """;
}