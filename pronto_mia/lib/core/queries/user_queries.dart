class UserQueries {
  static const users = """
    query users() {
      users {
        id
        userName
        department {
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
      \$accessControlList: AccessControlListInput!
    ) {
      createUser(
        userName: \$userName,
        password: \$password,
        departmentId: 1,
        accessControlList: \$accessControlList
      ) {
        id
      }
    }
  """;

  static const updateUser = """
     mutation updateUser(
      \$id: Int!, 
      \$userName: String!, 
      \$password: String!,
      \$accessControlList: AccessControlListInput!
    ) {
      updateUser(
        id: \$id,
        userName: \$userName,
        password: \$password,
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
