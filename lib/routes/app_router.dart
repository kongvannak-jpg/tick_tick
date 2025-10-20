import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tick_tick/constants/app_routes.dart';
import 'package:tick_tick/routes/route_config.dart';
import 'package:tick_tick/services/auth_guard_service.dart';
import 'package:tick_tick/providers/auth_provider.dart';

/// Main router provider that configures GoRouter with authentication
///
/// This provider creates a router instance that:
/// - Handles authentication-based routing
/// - Provides error handling
/// - Supports debugging in development mode
/// - Uses centralized route configuration
final routerProvider = Provider<GoRouter>((ref) {
  final authGuard = ref.read(authGuardServiceProvider);

  // Watch auth state to trigger router rebuilds when auth changes
  ref.watch(authStateProvider);

  return GoRouter(
    // Start with splash screen for proper initialization
    initialLocation: AppRoutes.splash,

    // Enable debug logging in development mode
    debugLogDiagnostics: kDebugMode,

    // Global redirect logic using auth guard service
    redirect: (context, state) => authGuard.getRedirectLocation(state),

    // Use centralized route configuration
    routes: RouteConfig.routes,

    // Add navigation observers for analytics, logging, etc.
    observers: RouteConfig.observers,

    // Handle route errors gracefully
    errorBuilder: RouteConfig.errorBuilder,

    // Refresh listenable when auth state changes
    refreshListenable: _AuthStateNotifier(ref),
  );
});

/// Custom listenable that notifies router when auth state changes
class _AuthStateNotifier extends ChangeNotifier {
  final Ref _ref;

  _AuthStateNotifier(this._ref) {
    // Listen to auth state changes
    _ref.listen<AuthState>(authStateProvider, (previous, next) {
      // Only notify if login status actually changed
      if (previous?.isLoggedIn != next.isLoggedIn) {
        notifyListeners();
      }
    });
  }
}
