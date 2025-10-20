import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tick_tick/constants/app_routes.dart';
import 'package:tick_tick/screens/enhanced_login_screen.dart';
import 'package:tick_tick/screens/home_screen.dart';
import 'package:tick_tick/screens/splash_screen.dart';

/// Route configuration for the application
///
/// This class encapsulates route definitions and provides a clean interface
/// for route management. It separates route configuration from the router provider.
class RouteConfig {
  /// Creates the list of application routes
  static List<RouteBase> get routes => [
    // Splash route (initial route)
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      builder: (context, state) => const SplashScreen(),
    ),

    // Authentication routes
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => const EnhancedLoginScreen(),
    ),

    // Protected routes
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.homeName,
      builder: (context, state) => const HomeScreen(),
    ),
  ];

  /// Creates navigation observers for analytics, logging, etc.
  static List<NavigatorObserver> get observers => [
    // Add your observers here
    // FirebaseAnalyticsObserver(analytics: analytics),
    // LoggingNavigatorObserver(),
  ];

  /// Error page builder for handling navigation errors
  static Widget errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.fullPath}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
