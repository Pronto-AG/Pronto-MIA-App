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

  static const createDeploymentPlan = """
    mutation addDeploymentPlan(
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
