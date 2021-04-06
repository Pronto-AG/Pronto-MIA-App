class UploadPdf {
  static const uploadPdf = """
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
