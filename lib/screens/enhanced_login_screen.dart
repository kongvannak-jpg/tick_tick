import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tick_tick/constants/app_constants.dart';
import 'package:tick_tick/providers/auth_provider.dart';
import 'package:tick_tick/widgets/login_form.dart';

/// Enhanced login screen with better architecture and maintainability
///
/// This screen focuses on layout and navigation logic while delegating
/// form logic to the LoginForm widget for better separation of concerns.
class EnhancedLoginScreen extends ConsumerWidget {
  const EnhancedLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for auth state changes to show errors
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.error != null) {
        _showErrorSnackBar(context, next.error!, ref);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // App branding section
                _buildBrandingSection(),

                const SizedBox(height: AppSizes.paddingXLarge),

                // Welcome text
                _buildWelcomeSection(),

                const SizedBox(height: AppSizes.paddingXLarge),

                // Login form
                LoginForm(
                  onLoginSuccess: () => _handleLoginSuccess(context),
                  onForgotPassword: () => _handleForgotPassword(context),
                  onRegister: () => _handleRegister(context),
                ),

                const SizedBox(height: AppSizes.paddingLarge),

                // Additional options (social login, etc.)
                _buildAdditionalOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingSection() {
    return Column(
      children: [
        // Logo
        Container(
          height: AppSizes.logoSize,
          width: AppSizes.logoSize,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shield_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),

        const SizedBox(height: AppSizes.paddingMedium),

        // Brand name
        const Text(
          AppStrings.brandName,
          style: TextStyle(
            fontSize: AppSizes.textMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return const Text(
      AppStrings.welcomeBack,
      style: TextStyle(
        fontSize: AppSizes.textHeading,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
              ),
              child: Text(
                'OR',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.textMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: AppSizes.paddingLarge),

        // Social login placeholder
        Text(
          'More login options coming soon',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppSizes.textMedium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showErrorSnackBar(BuildContext context, String error, WidgetRef ref) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSizes.paddingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ref.read(authStateProvider.notifier).clearError();
          },
        ),
      ),
    );
  }

  void _handleLoginSuccess(BuildContext context) {
    // Navigation is handled by the router automatically
    // This callback can be used for analytics, logging, etc.
    debugPrint('Login successful');
  }

  void _handleForgotPassword(BuildContext context) {
    // Navigate to forgot password screen
    // context.push(AppRoutes.forgotPassword);

    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Password'),
        content: const Text(
          'Forgot password functionality will be implemented soon.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleRegister(BuildContext context) {
    // Navigate to register screen
    // context.push(AppRoutes.register);

    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register'),
        content: const Text(
          'Registration functionality will be implemented soon.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
