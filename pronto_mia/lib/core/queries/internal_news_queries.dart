/// Groups all queries and mutations, which access the internal News GraphQL
/// type
class InternalNewsQueries {
  static const internalNews = """
    query internalNews() {
      internalNews(
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

  static const internalNewsById = """
    query internalNews(\$id: Int!) {
      internalNews (
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

  static const internalNewsAvailable = """
    query internalNewsAvailable() {
      internalNews(
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

  static const createInternalNews = """
    mutation createInternalNews(
      \$title: String!,
      \$description: String!,
      \$availableFrom: DateTime!,
      \$file: Upload!,
    ) {
      createInternalNews(
        title: \$title
        description: \$description,
        availableFrom: \$availableFrom,
        file: \$file,
      ) {
        id
      }
    }
  """;

  static const updateInternalNews = """
    mutation updateInternalNews(
      \$id: Int!,
      \$title: String,
      \$description: String,
      \$availableFrom: DateTime,
      \$file: Upload,
    ) {
      updateInternalNews(
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

  static const removeInternalNews = """
    mutation removeInternalNews(\$id: Int!) {
      removeInternalNews(id: \$id)
    }
  """;

  static const publishInternalNews = """
    mutation publishInternalNews(\$id: Int!, \$title: String!, \$body: String!) {
      publishInternalNews(id: \$id, title: \$title, body: \$body)
    }
  """;

  static const hideInternalNews = """
    mutation hideInternalNews(\$id: Int!) {
      hideInternalNews(id: \$id)
    }
  """;

  static const filterInternalNews = """
    query internalNews(\$filter: String!) { 
      internalNews(
        where: {
          or: [
            {title: {contains: \$filter}},
            {description: {contains: \$filter}},
          ]
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
}
