import 'dart:async';
import 'package:tick_tick/models/user.dart';
import 'package:tick_tick/utils/password_hasher.dart';
import 'package:tick_tick/services/google_sheets_database.dart';

class AuthService {
  // Simulated authentication service
  // In a real app, this would make HTTP requests to your backend

  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation for demo purposes
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Try Google Sheets login first
    try {
      final sheetsDb = GoogleSheetsDatabase();
      final hashedPassword = await PasswordManager.hashPassword(password);
      final user = await sheetsDb.loginUser(email, hashedPassword);
      if (user != null) {
        return user;
      }
    } catch (e) {
      print('Google Sheets login failed: $e');
    }

    // Fallback to demo login for testing
    // Simulate valid login
    if (email == 'test@example.com' && password == 'password') {
      return User(
        id: '1',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        position: 'Software Developer',
        avatar: null,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      );
    }

    // For demo, any email with valid format and password >= 6 chars will work
    if (email.contains('@') && email.contains('.')) {
      final name = email.split('@')[0];
      final nameParts = name.split('.');
      return User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        firstName: nameParts.isNotEmpty ? nameParts[0] : name,
        lastName: nameParts.length > 1 ? nameParts[1] : 'User',
        position: 'Employee',
        avatar: null,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
    }

    throw Exception('Invalid email or password');
  }

  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String position,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation for demo purposes
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        position.isEmpty) {
      throw Exception('All fields are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (!email.contains('@') || !email.contains('.')) {
      throw Exception('Please enter a valid email address');
    }

    // Simulate successful registration
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      firstName: firstName,
      lastName: lastName,
      position: position,
      avatar: null,
      createdAt: DateTime.now(),
    );
  }

  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, you might clear tokens, make logout API call, etc.
  }

  Future<User?> getCurrentUser() async {
    // In a real app, this would check stored tokens and validate with backend
    await Future.delayed(const Duration(milliseconds: 500));
    return null; // No user logged in initially
  }
}
