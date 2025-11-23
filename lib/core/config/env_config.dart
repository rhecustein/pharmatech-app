enum Environment {
  development,
  staging,
  production,
}

class EnvConfig {
  static Environment currentEnvironment = Environment.development;

  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'https://dev-api.pharmatech.com';
      case Environment.staging:
        return 'https://staging-api.pharmatech.com';
      case Environment.production:
        return 'https://api.pharmatech.com';
    }
  }

  static bool get isDevelopment => currentEnvironment == Environment.development;
  static bool get isStaging => currentEnvironment == Environment.staging;
  static bool get isProduction => currentEnvironment == Environment.production;

  static String get environmentName {
    switch (currentEnvironment) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
}
