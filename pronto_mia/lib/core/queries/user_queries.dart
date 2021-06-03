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
          canViewDeploymentPlans
		      canEditDeploymentPlans
		      canViewUsers
		      canEditUsers
		      canViewDepartments
		      canEditDepartments
        }
      }
    }
  """;

  static const userById = """
    query userById(\$id: Int!) {
      users(
        where: {
          id: {
            eq: \$id
          }
        }
      ) {
        id
        userName
        department {
          id
          name
        }
        accessControlList {
          canViewDeploymentPlans
          canEditDeploymentPlans
          canViewUsers
          canEditUsers
          canViewDepartments
          canEditDepartments
        }
      }
    }
  """;

  static const createUser = """
    mutation createUser(
      \$userName: String!, 
      \$password: String!, 
      \$departmentId: Int!,
      \$accessControlList: AccessControlListInput!
    ) {
      createUser(
        userName: \$userName,
        password: \$password,
        departmentId: \$departmentId,
        accessControlList: \$accessControlList
      ) {
        id
      }
    }
  """;

  static const updateUser = """
     mutation updateUser(
      \$id: Int!, 
      \$userName: String, 
      \$password: String,
      \$departmentId: Int,
      \$accessControlList: AccessControlListInput
    ) {
      updateUser(
        id: \$id,
        userName: \$userName,
        password: \$password,
        departmentId: \$departmentId,
        accessControlList: \$accessControlList
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
