/// Groups all queries and mutations, which access the mail GraphQL
/// type
class MailQueries {
  static const sendMail = """
    mutation sendMail(\$subject: String!,\$content: String!) {
        sendMail(subject: \$subject, content: \$content)
    }
  """;
}
