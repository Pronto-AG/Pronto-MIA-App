class LaunchesPast {
  static const readLaunchesPast = """
    query readLaunchesPast(\$limit: Int!) {
      launchesPast(limit: \$limit) {
        mission_name
      }
    }
  """;
}
