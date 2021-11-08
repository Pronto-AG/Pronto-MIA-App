/// Groups all queries and mutations, which access the external News GraphQL
/// type
class ExternalNewsQueries {
  static const externalNews =
      """
    query externalNews() {
      externalNews(
        order: {
          id: DESC
        }
      ) {
        id
        title
        description
        availableFrom
        link
        published
      }
    }
  """;

  static const externalNewsById =
      """
    query externalNews(\$id: Int!) {
      externalNews (
        where: { 
          id: { 
            eq: \$id
          }
        }
      ) {
        id
        title
        description
        availableFrom
        link
        published
      }
    }
  """;

  static const externalNewsAvailable =
      """
    query externalNewsAvailable() {
      externalNews(
        where: { 
          published: {
            eq: true
          },
        },
        order: {
          id: DESC
        }
      ) {
        id
        title
        description
        availableFrom
        link
        published
      }
    }
  """;

  static const createExternalNews =
      """
    mutation createExternalNews(
      \$title: String!,
      \$description: String!,
      \$availableFrom: DateTime!,
      \$file: Upload!,
    ) {
      createExternalNews(
        title: \$title
        description: \$description,
        availableFrom: \$availableFrom,
        file: \$file,
      ) {
        id
      }
    }
  """;

  static const updateExternalNews =
      """
    mutation updateExternalNews(
      \$id: Int!,
      \$title: String,
      \$description: String,
      \$availableFrom: DateTime,
      \$file: Upload,
    ) {
      updateExternalNews(
        id: \$id,
        title: \$title
        description: \$description,
        availableFrom: \$availableFrom,
        file: \$file,
      ) {
        id
      }
    }
  """;

  static const removeExternalNews =
      """
    mutation removeExternalNews(\$id: Int!) {
      removeExternalNews(id: \$id)
    }
  """;

  static const publishExternalNews =
      """
    mutation publishExternalNews(\$id: Int!, \$title: String!, \$body: String!) {
      publishExternalNews(id: \$id, title: \$title, body: \$body)
    }
  """;

  static const hideExternalNews =
      """
    mutation hideExternalNews(\$id: Int!) {
      hideExternalNews(id: \$id)
    }
  """;
}
