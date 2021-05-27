class UserQueries {
  static const users = """
    query users() {
      users {
        id
        userName
        department {
          id
          name
        }
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

  static const createUser = """
    mutation createUser(\$userName: String!, \$password: String!) {
      createUser(
        userName: \$userName,
        password: \$password,
        departmentId: 1,
        accessControlList: {
          canViewDeploymentPlans: true,
		      canEditDeploymentPlans: true,
		      canViewUsers: true,
		      canEditUsers: true,
		      canViewDepartments: true,
		      canEditDepartments: true
        }
      ) {
        id
      }
    }
  """;

  static const updateUser = """
     mutation updateUser(\$id: Int!, \$userName: String!, \$password: String!) {
      updateUser(
        id: \$id,
        userName: \$userName,
        password: \$password,
      ) {
        id
      }
    }
  """;

  static const removeUser = """
    mutation removeUser(\$id: Int!) {
      removeUser(id: \$id)
    }
  """;
}
