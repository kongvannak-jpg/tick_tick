import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:tick_tick/config/app_config.dart';

/// Advanced password management utility
/// Provides secure hashing, validation, and strength checking
class PasswordManager {
  static final _random = Random.secure();

  /// Hash a password using SHA-256 with configurable salt
  static String hashPassword(String password, {String? customSalt}) {
    final salt = customSalt ?? AppConfig.passwordSalt;
    final saltedPassword = password + salt;

    // Convert to bytes and hash
    final bytes = utf8.encode(saltedPassword);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// Verify a password against a hash
  static bool verifyPassword(
    String password,
    String hash, {
    String? customSalt,
  }) {
    final hashedPassword = hashPassword(password, customSalt: customSalt);
    return hashedPassword == hash;
  }

  /// Generate a secure random salt
  static String generateSalt({int length = 32}) {
    final bytes = List<int>.generate(length, (_) => _random.nextInt(256));
    return base64Encode(bytes);
  }

  /// Validate password strength and requirements
  static PasswordValidationResult validatePassword(String password) {
    var issues = <String>[];
    var score = 0;

    // Length validation
    if (password.length < AppConfig.minPasswordLength) {
      issues.add(
        'Password must be at least ${AppConfig.minPasswordLength} characters long',
      );
    } else {
      score += 1;
    }

    if (password.length > AppConfig.maxPasswordLength) {
      issues.add(
        'Password must not exceed ${AppConfig.maxPasswordLength} characters',
      );
    }

    // Character type validation
    if (!password.contains(RegExp(r'[a-z]'))) {
      issues.add('Password must contain at least one lowercase letter');
    } else {
      score += 1;
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      issues.add('Password must contain at least one uppercase letter');
    } else {
      score += 1;
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      issues.add('Password must contain at least one number');
    } else {
      score += 1;
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      issues.add('Password should contain at least one special character');
    } else {
      score += 1;
    }

    // Common password checks
    if (_isCommonPassword(password.toLowerCase())) {
      issues.add('Password is too common, please choose a different one');
      score = 0;
    }

    final strength = _calculateStrength(score, password.length);

    return PasswordValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
      strength: strength,
      score: score,
    );
  }

  /// Check if password is in common password list
  static bool _isCommonPassword(String password) {
    const commonPasswords = [
      'password',
      '123456',
      '123456789',
      'qwerty',
      'abc123',
      'password123',
      'admin',
      'letmein',
      'welcome',
      'monkey',
      'dragon',
      'master',
      'shadow',
      'superman',
      'batman',
    ];
    return commonPasswords.contains(password);
  }

  /// Calculate password strength based on score and length
  static PasswordStrength _calculateStrength(int score, int length) {
    if (score < 2) return PasswordStrength.weak;
    if (score < 4) return PasswordStrength.medium;
    if (score >= 4 && length >= 12) return PasswordStrength.strong;
    return PasswordStrength.medium;
  }

  /// Generate a secure random password
  static String generateSecurePassword({
    int length = 16,
    bool includeSymbols = true,
    bool includeNumbers = true,
    bool includeUppercase = true,
    bool includeLowercase = true,
  }) {
    var characters = '';

    if (includeLowercase) characters += 'abcdefghijklmnopqrstuvwxyz';
    if (includeUppercase) characters += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (includeNumbers) characters += '0123456789';
    if (includeSymbols) characters += '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    return List.generate(length, (_) {
      return characters[_random.nextInt(characters.length)];
    }).join();
  }

  /// Hash password with PBKDF2 (more secure for production)
  static String hashPasswordPBKDF2(
    String password,
    String salt, {
    int iterations = 10000,
  }) {
    final key = Hmac(sha256, utf8.encode(salt));
    var result = utf8.encode(password);

    for (int i = 0; i < iterations; i++) {
      final digest = key.convert(result);
      result = Uint8List.fromList(digest.bytes);
    }

    return base64Encode(result);
  }
}

/// Password validation result
class PasswordValidationResult {
  final bool isValid;
  final List<String> issues;
  final PasswordStrength strength;
  final int score;

  const PasswordValidationResult({
    required this.isValid,
    required this.issues,
    required this.strength,
    required this.score,
  });
}

/// Password strength levels
enum PasswordStrength { weak, medium, strong }

extension PasswordStrengthExtension on PasswordStrength {
  String get label {
    switch (this) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  int get colorValue {
    switch (this) {
      case PasswordStrength.weak:
        return 0xFFE74C3C; // Red
      case PasswordStrength.medium:
        return 0xFFF39C12; // Orange
      case PasswordStrength.strong:
        return 0xFF27AE60; // Green
    }
  }
}
