class AppConfig {
  static const String appName = 'PharmaTech';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.pharmatech.com';
  static const String apiVersion = 'v1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheMaxAge = Duration(hours: 1);
  static const int maxCacheSize = 100; // MB

  // Images
  static const int imageQuality = 85;
  static const int maxImageSize = 5; // MB

  // Biometric
  static const String biometricReason = 'Masuk ke PharmaTech';

  // Support
  static const String supportEmail = 'support@pharmatech.com';
  static const String supportPhone = '+62 812 3456 7890';
}
