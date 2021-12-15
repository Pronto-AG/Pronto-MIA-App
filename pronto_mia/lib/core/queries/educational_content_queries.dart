/// Groups all queries and mutations, which access the educational Content
/// GraphQL type
class EducationalContentQueries {
  static const educationalContent = """
    query educationalContent() {
      educationalContent(
        order: {
          id: DESC
        }
      ) {
        id
        title
        description
        link
        published
      }
    }
  """;

  static const educationalContentById = """
    query educationalContent(\$id: Int!) {
      educationalContent (
        where: { 
          id: { 
            eq: \$id
          }
        }
      ) {
        id
        title
        description
        link
        published
      }
    }
  """;

  static const educationalContentAvailable = """
    query educationalContentAvailable() {
      educationalContent(
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
        link
        published
      }
    }
  """;

  static const createEducationalContent = """
    mutation createEducationalContent(
      \$title: String!,
      \$description: String!,
      \$file: Upload!,
    ) {
      createEducationalContent(
        title: \$title
        description: \$description,
        file: \$file,
      ) {
        id
      }
    }
  """;

  static const updateEducationalContent = """
    mutation updateEducationalContent(
      \$id: Int!,
      \$title: String,
      \$description: String,
      \$file: Upload,
    ) {
      updateEducationalContent(
        id: \$id,
        title: \$title
        description: \$description,
        file: \$file,
      ) {
        id
      }
    }
  """;

  static const removeEducationalContent = """
    mutation removeEducationalContent(\$id: Int!) {
      removeEducationalContent(id: \$id)
    }
  """;

  static const publishEducationalContent = """
    mutation publishEducationalContent(\$id: Int!, \$title: String!, \$body: String!) {
      publishEducationalContent(id: \$id, title: \$title, body: \$body)
    }
  """;

  static const hideEducationalContent = """
    mutation hideEducationalContent(\$id: Int!) {
      hideEducationalContent(id: \$id)
    }
  """;

  static const filterEducationalContent = """
    query educationalContent(\$filter: String!) { 
      educationalContent(
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
            link
            published
        }
    }
  """;
}
