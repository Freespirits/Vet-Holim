enum AppEnvironment { dev, staging, production }

class SharedConfig {
  const SharedConfig({required this.environment, required this.enableAudit});

  final AppEnvironment environment;
  final bool enableAudit;
}
