/// Group all queries and mutations, which access the firebase cloud messaging
/// token
class FcmTokenQueries {
  static const registerFcmToken = """
    mutation registerFcmToken(\$fcmToken: String!) {
      registerFcmToken(fcmToken: \$fcmToken) {
        id
      }
    }
  """;

  static const unregisterFcmToken = """
    mutation unregisterFcmToken(\$fcmToken: String!) {
      unregisterFcmToken(token: \$fcmToken)
    }
  """;
}
