class AuthenticationQueries {
  static const authenticate = """
    query authenticate(\$userName: String!, \$password: String!) {
      authenticate(userName: \$userName, password: \$password)
    }
  """;

  static const changePassword = """
    mutation changePassword(
      \$oldPassword: String!, 
      \$newPassword: String!
    ) {
      changePassword(
        oldPassword: \$oldPassword, 
        newPassword: \$newPassword
      )
    }
  """;
}
