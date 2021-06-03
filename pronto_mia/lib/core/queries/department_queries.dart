class DepartmentQueries {
  static const departments = """
    query departments() {
      departments {
        id
        name
      }
    }
  """;

  static const createDepartment = """
    mutation createDepartment(\$name: String!) {
      createDepartment(name: \$name) {
        id
      }
    }
  """;

  static const updateDepartment = """
    mutation updateDepartment(\$id: Int!, \$name: String!) {
      updateDepartment(id: \$id, name: \$name) {
        id
      }
    }
  """;

  static const removeDepartment = """
    mutation removeDepartment(\$id: Int!) {
      removeDepartment(id: \$id)
    }
  """;
}
