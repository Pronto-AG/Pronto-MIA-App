class DeploymentPlanQueries {
  static const deploymentPlans = """
    query deploymentPlans() {
      deploymentPlans {
        id
        description
        availableFrom
        availableUntil
        link
        published
        department {
          id
          name
        }
      }
    }
  """;

  static const deploymentPlanById = """
    query deploymentPlans(\$id: Int!) {
      deploymentPlans (
        where: { 
          id: { 
            eq: \$id
          }
        }
      ) {
        id
        description
        availableFrom
        availableUntil
        link
        published
        department {
          id
          name
        }
      }
    }
  """;

  static const deploymentPlansAvailableUntil = """
    query deploymentPlansAvailableUntil(\$availableUntil: DateTime!) {
      deploymentPlans(
        where: { 
          availableUntil: { 
            gte: \$availableUntil
          },
          published: {
            eq: true
          }
        }
      ) {
        id
        description
        availableFrom
        availableUntil
        link
        published
        department {
          id
          name
        }
      }
    }
  """;

  static const createDeploymentPlan = """
    mutation createDeploymentPlan(
      \$description: String,
      \$file: Upload!,
      \$availableFrom: DateTime!,
      \$availableUntil: DateTime!
      \$departmentId: Int!,
    ) {
      createDeploymentPlan(
        description: \$description,
        file: \$file,
        availableFrom: \$availableFrom,
        availableUntil: \$availableUntil
        departmentId: \$departmentId,
      ) {
        id
      }
    }
  """;

  static const updateDeploymentPlan = """
    mutation updateDeploymentPlan(
      \$id: Int!,
      \$description: String,
      \$file: Upload,
      \$availableFrom: DateTime,
      \$availableUntil: DateTime
      \$departmentId: Int,
    ) {
      updateDeploymentPlan(
        id: \$id,
        description: \$description,
        file: \$file,
        availableFrom: \$availableFrom,
        availableUntil: \$availableUntil,
        departmentId: \$departmentId,
      ) {
        id
      }
    }
  """;

  static const removeDeploymentPlan = """
    mutation removeDeploymentPlan(\$id: Int!) {
      removeDeploymentPlan(id: \$id)
    }
  """;

  static const publishDeploymentPlan = """
    mutation publishDeploymentPlan(\$id: Int!, \$title: String!, \$body: String!) {
      publishDeploymentPlan(id: \$id, title: \$title, body: \$body)
    }
  """;

  static const hideDeploymentPlan = """
    mutation hideDeploymentPlan(\$id: Int!) {
      hideDeploymentPlan(id: \$id)
    }
  """;
}
