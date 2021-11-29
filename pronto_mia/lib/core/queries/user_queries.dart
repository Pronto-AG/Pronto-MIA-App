/// Groups all queries and mutations, which access the User GraphQL type
class UserQueries {
  static const users =
      """
    query users() {
      users {
        id
        userName
        departments {
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
          canEditExternalNews
        }
      }
    }
  """;

  static const currentUser =
      """
    query currentUser() {
      user {
        id
        userName
        departments {
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
          canEditExternalNews
        }   
      }
    }
  """;

  static const createUser =
      """
    mutation createUser(
      \$userName: String!, 
      \$password: String!, 
      \$departmentIds: [Int!],
      \$accessControlList: AccessControlListInput!
    ) {
      createUser(
        userName: \$userName,
        password: \$password,
        departmentIds: \$departmentIds,
        accessControlList: \$accessControlList
      ) {
        id
      }
    }
  """;

  static const updateUser =
      """
     mutation updateUser(
      \$id: Int!, 
      \$userName: String, 
      \$password: String,
      \$departmentIds: [Int!],
      \$accessControlList: AccessControlListInput
    ) {
      updateUser(
        id: \$id,
        userName: \$userName,
        password: \$password,
        departmentIds: \$departmentIds,
        accessControlList: \$accessControlList
      ) {
        id
      }
    }
  """;

  static const removeUser =
      """
    mutation removeUser(\$id: Int!) {
      removeUser(id: \$id)
    }
  """;

  static const filterUser =
      """
    query users(\$filter: String!) { 
      users(
        where: {
          userName: {contains: \$filter }
        }
        ) {
            id
            userName
            departments {
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
                canEditExternalNews
            }
          }
        }
    """;
}
