class Authenticate {
  static const authenticate = """
    query authenticate(\$userName: String!, \$password: String!) {
      authenticate(userName: \$userName, password: \$password)
    }
  """;
}