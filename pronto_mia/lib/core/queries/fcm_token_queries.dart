class FcmTokenQueries {
  static const registerFcmToken = """
    mutation registerFcmToken(\$fcmToken: String!) {
      registerFcmToken(fcmToken: \$fcmToken) {
        id
      }
    }
  """;

  // TODO: Rename token -> fcmToken
  static const unregisterFcmToken = """
    mutation unregisterFcmToken(\$fcmToken: String!) {
      unregisterFcmToken(token: \$fcmToken)
    }
  """;
}
