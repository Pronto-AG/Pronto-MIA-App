class FcmTokenQueries {
  static const registerFcmToken = """
    mutation registerFcmToken(\$fcmToken: String!) {
      registerFcmToken(fcmToken: \$fcmToken) {
        id
        owner {
          id
          userName
        }
      }
    }
  """;
}