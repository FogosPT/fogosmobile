class Environment {
  final String baseUrl;

  const Environment({required this.baseUrl});

  factory Environment.dev(String baseUrl) {
    return Environment(baseUrl: baseUrl);
  }

  factory Environment.production(String baseUrl) {
    return Environment(baseUrl: baseUrl);
  }

  factory Environment.staging(String baseUrl) {
    return Environment(baseUrl: baseUrl);
  }
}
