/// Group all queries and mutations, which access the User GraphQL type
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
          canViewDepartmentDeploymentPlans
		      canEditDeploymentPlans
		      canEditDepartmentDeploymentPlans
		      canViewUsers
		      canViewDepartmentUsers
		      canEditUsers
		      canEditDepartmentUsers
		      canViewDepartments
		      canViewOwnDepartment
		      canEditDepartments
		      canEditOwnDepartment
        }
      }
    }
  """;

  static const currentUser = """
    query currentUser() {
      user {
        id
        userName
        department {
          id
          name
        }
        accessControlList {
          canViewDeploymentPlans
          canViewDepartmentDeploymentPlans
          canEditDeploymentPlans
          canEditDepartmentDeploymentPlans
          canViewUsers
          canViewDepartmentUsers
          canEditUsers
          canEditDepartmentUsers
          canViewDepartments
          canViewOwnDepartment
          canEditDepartments
          canEditOwnDepartment
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
