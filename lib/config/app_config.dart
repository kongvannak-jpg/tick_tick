/// Application configuration management
/// Centralized place for all app settings
class AppConfig {
  // Google Sheets Configuration
  static const String googleSheetId =
      '1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs';
  static const String googleAppsScriptUrl =
      'https://script.google.com/macros/s/AKfycbzJI4OTjWbUACS2fptIvM08I-GGF7fjNTS8S11QYynQi4vwa6TCbO1ad5B3DiznqB3wJw/exec';

  // Security Configuration
  static const String passwordSalt = 'ticktick_salt_2025';
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;

  // API Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double borderRadius = 12.0;
  static const double spacing = 16.0;

  // App Information
  static const String appName = 'TickTick';
  static const String appVersion = '1.0.0';
  static const String apiVersion = 'v1';

  // Validation Rules
  static const Map<String, ValidationRule> validationRules = {
    'email': ValidationRule(
      pattern: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      message: 'Please enter a valid email address',
    ),
    'name': ValidationRule(
      minLength: 2,
      maxLength: 50,
      message: 'Name must be between 2 and 50 characters',
    ),
    'position': ValidationRule(
      minLength: 2,
      maxLength: 100,
      message: 'Position must be between 2 and 100 characters',
    ),
  };

  // Feature Flags
  static const Map<String, bool> features = {
    'enableGoogleSheetsIntegration': true,
    'enablePasswordHashing': true,
    'enableOfflineMode': false,
    'enableBiometricAuth': false,
    'enablePushNotifications': false,
    'enableAnalytics': false,
    'enableCrashReporting': true,
  };

  // Environment Configuration
  static const AppEnvironment environment = AppEnvironment.development;

  // Get feature flag value
  static bool isFeatureEnabled(String feature) {
    return features[feature] ?? false;
  }

  // Get validation rule
  static ValidationRule? getValidationRule(String field) {
    return validationRules[field];
  }
}

/// Validation rule configuration
class ValidationRule {
  final String? pattern;
  final int? minLength;
  final int? maxLength;
  final String message;

  const ValidationRule({
    this.pattern,
    this.minLength,
    this.maxLength,
    required this.message,
  });
}

/// Application environment
enum AppEnvironment { development, staging, production }

/// Environment-specific configurations
extension AppEnvironmentExtension on AppEnvironment {
  bool get isDevelopment => this == AppEnvironment.development;
  bool get isStaging => this == AppEnvironment.staging;
  bool get isProduction => this == AppEnvironment.production;

  String get name {
    switch (this) {
      case AppEnvironment.development:
        return 'development';
      case AppEnvironment.staging:
        return 'staging';
      case AppEnvironment.production:
        return 'production';
    }
  }
}
