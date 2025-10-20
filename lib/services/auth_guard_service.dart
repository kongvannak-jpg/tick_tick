import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tick_tick/constants/app_routes.dart';
import 'package:tick_tick/providers/auth_provider.dart';

/// Authentication guard service for route protection
///
/// This service handles route-level authentication logic and redirects.
/// It's designed to be easily testable and configurable.
class AuthGuardService {
  final Ref _ref;

  const AuthGuardService(this._ref);

  /// Determines where to redirect based on current auth state and target route
  String? getRedirectLocation(GoRouterState state) {
    final authState = _ref.read(authStateProvider);
    final currentPath = state.fullPath ?? '/';

    // If user is not authenticated
    if (!authState.isLoggedIn) {
      return _handleUnauthenticatedUser(currentPath);
    }

    // If user is authenticated
    return _handleAuthenticatedUser(currentPath);
  }

  /// Handle redirect logic for unauthenticated users
  String? _handleUnauthenticatedUser(String currentPath) {
    // Allow access to auth routes and splash
    if (AppRoutes.isAuthRoute(currentPath) || currentPath == AppRoutes.splash) {
      return null; // No redirect needed
    }

    // Redirect to login for protected routes
    if (AppRoutes.isProtectedRoute(currentPath)) {
      return AppRoutes.login;
    }

    // For unknown routes, redirect to splash
    return AppRoutes.splash;
  }

  /// Handle redirect logic for authenticated users
  String? _handleAuthenticatedUser(String currentPath) {
    // Redirect away from auth routes to home
    if (AppRoutes.isAuthRoute(currentPath)) {
      return AppRoutes.home;
    }

    // Redirect from splash to home
    if (currentPath == AppRoutes.splash) {
      return AppRoutes.home;
    }

    // Allow access to protected routes
    return null;
  }

  /// Check if a route transition should be animated
  bool shouldAnimateTransition(String fromPath, String toPath) {
    // Don't animate splash transitions
    if (fromPath == AppRoutes.splash || toPath == AppRoutes.splash) {
      return false;
    }

    // Don't animate auth redirects
    if (AppRoutes.isAuthRoute(fromPath) && AppRoutes.isProtectedRoute(toPath)) {
      return false;
    }

    return true;
  }
}

/// Provider for the auth guard service
final authGuardServiceProvider = Provider<AuthGuardService>((ref) {
  return AuthGuardService(ref);
});
