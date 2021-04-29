class DeploymentPlanQueries {
  static const deploymentPlans = """
    query deploymentPlans() {
      deploymentPlans {
        id
        description
        availableFrom
        availableUntil
        link
      }
    }
  """;

  static const deploymentPlansAvailableUntil = """
    query deploymentPlansAvailableUntil(\$availableUntil: DateTime!) {
      deploymentPlans(
        where: { 
          availableUntil: { 
            gte: \$availableUntil
          }
        }
      ) {
        id
        description
        availableFrom
        availableUntil
        link
      }
    }
  """;

  static const addDeploymentPlan = """
    mutation addDeploymentPlan(
      \$description: String,
      \$file: Upload!,
      \$availableFrom: DateTime!,
      \$availableUntil: DateTime!
    ) {
      addDeploymentPlan(
        description: \$description,
        file: \$file,
        availableFrom: \$availableFrom,
        availableUntil: \$availableUntil
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
    ) {
      updateDeploymentPlan(
        id: \$id,
        description: \$description,
        file: \$file,
        availableFrom: \$availableFrom,
        availableUntil: \$availableUntil,
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
}
