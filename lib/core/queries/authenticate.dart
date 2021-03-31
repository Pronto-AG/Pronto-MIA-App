class Authenticate {
  static const authenticate = """
    query authenticate(\$username: String, \$password: String) {
      authenticate(username: \$username, password: \$password)
    }
  """;
}