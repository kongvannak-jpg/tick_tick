import 'package:tick_tick/interfaces/database_interface.dart';
import 'package:tick_tick/services/google_sheets_database.dart';
import 'package:tick_tick/config/app_config.dart';
import 'package:tick_tick/models/user.dart';

/// Database factory for creating different database implementations
/// Supports multiple database backends for scalability
class DatabaseFactory {
  static DatabaseInterface? _instance;

  /// Get database instance based on configuration
  static DatabaseInterface getInstance({DatabaseType? type}) {
    _instance ??= _createDatabase(type ?? _getDefaultDatabaseType());
    return _instance!;
  }

  /// Create specific database implementation
  static DatabaseInterface _createDatabase(DatabaseType type) {
    switch (type) {
      case DatabaseType.googleSheets:
        return GoogleSheetsDatabase();
      case DatabaseType.firebase:
        return FirebaseDatabase();
      case DatabaseType.sqlite:
        return SQLiteDatabase();
      case DatabaseType.mock:
        return MockDatabase();
    }
  }

  /// Get default database type from configuration
  static DatabaseType _getDefaultDatabaseType() {
    if (AppConfig.isFeatureEnabled('enableGoogleSheetsIntegration')) {
      return DatabaseType.googleSheets;
    }
    return DatabaseType.sqlite;
  }

  /// Reset instance (useful for testing)
  static void resetInstance() {
    _instance = null;
  }

  /// Switch database type at runtime
  static void switchDatabase(DatabaseType type) {
    _instance = _createDatabase(type);
  }
}

/// Available database types
enum DatabaseType { googleSheets, firebase, sqlite, mock }

/// Mock database for testing
class MockDatabase implements DatabaseInterface {
  final List<Map<String, dynamic>> _users = [];

  @override
  bool get isConfigured => true;

  @override
  Future<bool> saveUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String position,
    required String createdAt,
    String? password,
  }) async {
    _users.add({
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'position': position,
      'password': password,
      'createdAt': createdAt,
    });
    return true;
  }

  @override
  Future<User?> loginUser(String email, String hashedPassword) async {
    final userData = _users.firstWhere(
      (user) => user['email'] == email && user['password'] == hashedPassword,
      orElse: () => {},
    );

    if (userData.isEmpty) return null;

    return User(
      id: userData['id'],
      email: userData['email'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      position: userData['position'],
      avatar: null,
      createdAt: DateTime.parse(userData['createdAt']),
    );
  }

  @override
  Future<User?> getUserById(String id) async {
    final userData = _users.firstWhere(
      (user) => user['id'] == id,
      orElse: () => {},
    );

    if (userData.isEmpty) return null;

    return User(
      id: userData['id'],
      email: userData['email'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      position: userData['position'],
      avatar: null,
      createdAt: DateTime.parse(userData['createdAt']),
    );
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final userData = _users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {},
    );

    if (userData.isEmpty) return null;

    return User(
      id: userData['id'],
      email: userData['email'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      position: userData['position'],
      avatar: null,
      createdAt: DateTime.parse(userData['createdAt']),
    );
  }

  @override
  Future<bool> updateUser(User user) async {
    final index = _users.indexWhere((u) => u['id'] == user.id);
    if (index != -1) {
      _users[index] = {
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'position': user.position,
        'createdAt': user.createdAt.toIso8601String(),
      };
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteUser(String id) async {
    final index = _users.indexWhere((user) => user['id'] == id);
    if (index != -1) {
      _users.removeAt(index);
      return true;
    }
    return false;
  }

  @override
  Future<List<User>> getUsers({int page = 1, int limit = 50}) async {
    final startIndex = (page - 1) * limit;

    final paginatedUsers = _users.skip(startIndex).take(limit).toList();

    return paginatedUsers
        .map(
          (userData) => User(
            id: userData['id'],
            email: userData['email'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            position: userData['position'],
            avatar: null,
            createdAt: DateTime.parse(userData['createdAt']),
          ),
        )
        .toList();
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    final filteredUsers = _users
        .where(
          (user) =>
              user['firstName'].toLowerCase().contains(query.toLowerCase()) ||
              user['lastName'].toLowerCase().contains(query.toLowerCase()) ||
              user['email'].toLowerCase().contains(query.toLowerCase()) ||
              user['position'].toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return filteredUsers
        .map(
          (userData) => User(
            id: userData['id'],
            email: userData['email'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            position: userData['position'],
            avatar: null,
            createdAt: DateTime.parse(userData['createdAt']),
          ),
        )
        .toList();
  }

  @override
  Future<bool> testConnection() async {
    return true;
  }
}

// Placeholder classes for future implementations
class FirebaseDatabase implements DatabaseInterface {
  @override
  bool get isConfigured => false;

  @override
  Future<bool> saveUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String position,
    required String createdAt,
    String? password,
  }) async {
    throw UnimplementedError('Firebase database not implemented yet');
  }

  @override
  Future<User?> loginUser(String email, String hashedPassword) async {
    throw UnimplementedError('Firebase database not implemented yet');
  }

  @override
  Future<User?> getUserById(String id) async {
    throw UnimplementedError('Firebase database not implemented yet');
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    throw UnimplementedError('Firebase database not implemented yet');
  }

  @override
  Future<bool> updateUser(User user) async {
    throw UnimplementedError('Firebase database not implemented yet');
  }

  @override
  Future<bool> deleteUser(String id) async {
    throw UnimplementedError('Firebase database not implemented yet');
  }

  @override
  Future<List<User>> getUsers({int page = 1, int limit = 50}) async {
    throw UnimplementedError('Firebase database not implemented yet');
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    throw UnimplementedError('Firebase database not implemented yet');
  }

  @override
  Future<bool> testConnection() async {
    throw UnimplementedError('Firebase database not implemented yet');
  }
}

class SQLiteDatabase implements DatabaseInterface {
  @override
  bool get isConfigured => false;

  @override
  Future<bool> saveUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String position,
    required String createdAt,
    String? password,
  }) async {
    throw UnimplementedError('SQLite database not implemented yet');
  }

  @override
  Future<User?> loginUser(String email, String hashedPassword) async {
    throw UnimplementedError('SQLite database not implemented yet');
  }

  @override
  Future<User?> getUserById(String id) async {
    throw UnimplementedError('SQLite database not implemented yet');
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    throw UnimplementedError('SQLite database not implemented yet');
  }

  @override
  Future<bool> updateUser(User user) async {
    throw UnimplementedError('SQLite database not implemented yet');
  }

  @override
  Future<bool> deleteUser(String id) async {
    throw UnimplementedError('SQLite database not implemented yet');
  }

  @override
  Future<List<User>> getUsers({int page = 1, int limit = 50}) async {
    throw UnimplementedError('SQLite database not implemented yet');
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    throw UnimplementedError('SQLite database not implemented yet');
  }

  @override
  Future<bool> testConnection() async {
    throw UnimplementedError('SQLite database not implemented yet');
  }
}
