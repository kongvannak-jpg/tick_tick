import 'package:tick_tick/models/user.dart';

/// Abstract database interface for scalability
/// Allows switching between different database implementations
abstract class DatabaseInterface {
  /// Save a user to the database
  Future<bool> saveUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String position,
    required String createdAt,
    String? password,
  });

  /// Login user with email and password
  Future<User?> loginUser(String email, String hashedPassword);

  /// Get user by ID
  Future<User?> getUserById(String id);

  /// Get user by email
  Future<User?> getUserByEmail(String email);

  /// Update user information
  Future<bool> updateUser(User user);

  /// Delete user
  Future<bool> deleteUser(String id);

  /// Get all users (with pagination)
  Future<List<User>> getUsers({int page = 1, int limit = 50});

  /// Search users
  Future<List<User>> searchUsers(String query);

  /// Check if database is configured and ready
  bool get isConfigured;

  /// Test database connection
  Future<bool> testConnection();
}

/// Database operation result
class DatabaseResult<T> {
  final bool success;
  final T? data;
  final String? error;
  final Map<String, dynamic>? metadata;

  const DatabaseResult({
    required this.success,
    this.data,
    this.error,
    this.metadata,
  });

  factory DatabaseResult.success(T data, {Map<String, dynamic>? metadata}) {
    return DatabaseResult(success: true, data: data, metadata: metadata);
  }

  factory DatabaseResult.failure(
    String error, {
    Map<String, dynamic>? metadata,
  }) {
    return DatabaseResult(success: false, error: error, metadata: metadata);
  }
}

/// Database query options
class QueryOptions {
  final int page;
  final int limit;
  final String? sortBy;
  final bool ascending;
  final Map<String, dynamic>? filters;

  const QueryOptions({
    this.page = 1,
    this.limit = 50,
    this.sortBy,
    this.ascending = true,
    this.filters,
  });
}
