/// Groups all queries and mutations, which access the appointment GraphQL
/// type
class AppointmentQueries {
  static const appointments = """
    query appointments() {
      appointments(
        order: {
          id: DESC
        }
      ) {
        id
        title
        location
        from
        to
        isAllDay
        isYearly
      }
    }
  """;

  static const createAppointment = """
    mutation createAppointment(
      \$title: String!,
      \$location: String!,
      \$from: DateTime!,
      \$to: DateTime!,
      \$isAllDay: Boolean!,
      \$isYearly: Boolean!,
    ) {
      createAppointment(
        title: \$title,
        location: \$location,
        from: \$from,
        to: \$to,
        isAllDay: \$isAllDay,
        isYearly: \$isYearly,
      ) {
        id
      }
    }
  """;

  static const updateAppointment = """
    mutation updateAppointment(
      \$id: Int!,
      \$title: String,
      \$location: String,
      \$from: DateTime,
      \$to: DateTime,
      \$isAllDay: Boolean!,
      \$isYearly: Boolean!,
    ) {
      updateAppointment(
        id: \$id,
        title: \$title,
        location: \$location,
        from: \$from,
        to: \$to,
        isAllDay: \$isAllDay,
        isYearly: \$isYearly,
      ) {
        id
      }
    }
  """;

  static const removeAppointment = """
    mutation removeAppointment(\$id: Int!) {
      removeAppointment(id: \$id)
    }
  """;
}
