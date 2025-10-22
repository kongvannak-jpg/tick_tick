/// Application route paths and names
///
/// This class centralizes all route definitions to ensure consistency
/// and prevent typos when navigating between screens.
class AppRoutes {
  // Route paths
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String dataSync = '/data-sync';
  static const String sheetsSync = '/sheets-sync';
  static const String simpleSheetsSync = '/simple-sheets-sync';
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  // Route names (for named navigation)
  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String forgotPasswordName = 'forgot-password';
  static const String homeName = 'home';
  static const String profileName = 'profile';
  static const String dataSyncName = 'data-sync';
  static const String sheetsSyncName = 'sheets-sync';
  static const String simpleSheetsSyncName = 'simple-sheets-sync';
  static const String settingsName = 'settings';
  static const String notificationsName = 'notifications';

  // Route groups for easier organization
  static const List<String> authRoutes = [login, register, forgotPassword];

  static const List<String> protectedRoutes = [
    home,
    profile,
    dataSync,
    settings,
    notifications,
  ];

  /// Check if a route requires authentication
  static bool isProtectedRoute(String path) {
    return protectedRoutes.contains(path);
  }

  /// Check if a route is an auth route
  static bool isAuthRoute(String path) {
    return authRoutes.contains(path);
  }
}
