import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4169E1); // Royal Blue
  static const Color primaryDark = Color(0xFF2E4BC7);
  static const Color primaryLight = Color(0xFF6B8AFF);

  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;

  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textDisabled = Colors.black38;

  static Color get inputFill => Colors.grey[50]!;
  static Color get inputBorder => Colors.grey[300]!;
}

class AppStrings {
  static const String appName = 'Tick Tick';
  static const String brandName = 'KE MOK HERY';

  // Auth screens
  static const String welcomeBack = 'Welcome Back';
  static const String emailHint = 'Email Address';
  static const String passwordHint = 'Password';
  static const String rememberMe = 'Remember Me';
  static const String login = 'Login';
  static const String noAccount = "Don't have any account yet? ";
  static const String registerHere = 'Register Here';

  // Validation messages
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordMinLength =
      'Password must be at least 6 characters';

  // Home screen
  static const String welcomeUser = 'Welcome';
  static const String logoutConfirm = 'Are you sure you want to logout?';
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;
  static const double iconSize = 24.0;
  static const double logoSize = 80.0;

  static const double textSmall = 12.0;
  static const double textMedium = 14.0;
  static const double textLarge = 16.0;
  static const double textXLarge = 18.0;
  static const double textTitle = 24.0;
  static const double textHeading = 32.0;
}
