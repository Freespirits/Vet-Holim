class FeatureFlags {
  const FeatureFlags({
    required this.enableOfflineSync,
    required this.enableAuditTrail,
    required this.enableClinicaIntegration,
  });

  final bool enableOfflineSync;
  final bool enableAuditTrail;
  final bool enableClinicaIntegration;
}

class Environment {
  const Environment({
    required this.name,
    required this.apiBaseUrl,
    required this.featureFlags,
  });

  final String name;
  final String apiBaseUrl;
  final FeatureFlags featureFlags;
}

FeatureFlags _defaultFlags() => const FeatureFlags(
      enableOfflineSync: true,
      enableAuditTrail: true,
      enableClinicaIntegration: false,
    );

Environment buildEnvironment() {
  const env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  switch (env) {
    case 'production':
      return Environment(
        name: 'production',
        apiBaseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.vetholim.local'),
        featureFlags: _defaultFlags(),
      );
    case 'staging':
      return Environment(
        name: 'staging',
        apiBaseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'https://staging-api.vetholim.local'),
        featureFlags: _defaultFlags(),
      );
    default:
      return Environment(
        name: 'dev',
        apiBaseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:4000'),
        featureFlags: _defaultFlags(),
      );
  }
}
