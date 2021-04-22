class DeploymentPlanQueries {
  static const deploymentPlans = """
    query deploymentPlans() {
      deploymentPlans {
        id
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
        availableFrom
        availableUntil
        link
      }
    }
  """;

  // TODO: Add description to query
  static const createDeploymentPlan = """
    mutation addDeploymentPlan(
      \$description: String!,
      \$file: Upload!,
      \$availableFrom: DateTime!,
      \$availableUntil: DateTime!
    ) {
      addDeploymentPlan(
        file: \$file,
        availableFrom: \$availableFrom,
        availableUntil: \$availableUntil
      ) {
        link
      }
    }
  """;
}
