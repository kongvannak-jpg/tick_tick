import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tick_tick/constants/app_constants.dart';
import 'package:tick_tick/providers/auth_provider.dart';
import 'package:tick_tick/services/form_validation_service.dart';
import 'package:tick_tick/widgets/custom_text_field.dart';
import 'package:tick_tick/widgets/custom_button.dart';

/// Enhanced login form widget with better validation and UX
///
/// This widget encapsulates all login form logic and can be easily
/// tested and reused across different screens.
class LoginForm extends ConsumerStatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onRegister;

  const LoginForm({
    super.key,
    this.onLoginSuccess,
    this.onForgotPassword,
    this.onRegister,
  });

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _setupFormListeners();
  }

  void _setupFormListeners() {
    // Listen to text changes to enable/disable login button
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref
          .read(authStateProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      // Call success callback if login succeeded
      if (mounted) {
        final authState = ref.read(authStateProvider);
        if (authState.isLoggedIn) {
          widget.onLoginSuccess?.call();
        }
      }
    } catch (e) {
      // Error handling is done in the auth provider
      // and will be displayed via the listener in the parent widget
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          CustomTextField(
            controller: _emailController,
            hintText: AppStrings.emailHint,
            keyboardType: TextInputType.emailAddress,
            validator: FormValidationService.validateEmail,
            enabled: !authState.isLoading,
            autofillHints: const [AutofillHints.email],
          ),

          const SizedBox(height: AppSizes.paddingMedium),

          // Password field
          CustomTextField(
            controller: _passwordController,
            hintText: AppStrings.passwordHint,
            obscureText: _obscurePassword,
            validator: FormValidationService.validatePassword,
            enabled: !authState.isLoading,
            autofillHints: const [AutofillHints.password],
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ),

          const SizedBox(height: AppSizes.paddingMedium),

          // Remember me checkbox
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: authState.isLoading ? null : _toggleRememberMe,
                activeColor: AppColors.primary,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: authState.isLoading
                      ? null
                      : () => _toggleRememberMe(!_rememberMe),
                  child: Text(
                    AppStrings.rememberMe,
                    style: TextStyle(
                      fontSize: AppSizes.textMedium,
                      color: authState.isLoading
                          ? AppColors.textDisabled
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: authState.isLoading ? null : widget.onForgotPassword,
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: AppSizes.textMedium,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSizes.paddingLarge),

          // Login button
          CustomButton(
            text: AppStrings.login,
            onPressed: (authState.isLoading || !_isFormValid)
                ? null
                : _handleLogin,
            isLoading: authState.isLoading,
          ),

          const SizedBox(height: AppSizes.paddingLarge),

          // Register link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.noAccount,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSizes.textMedium,
                ),
              ),
              TextButton(
                onPressed: authState.isLoading ? null : widget.onRegister,
                child: const Text(
                  AppStrings.registerHere,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: AppSizes.textMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
