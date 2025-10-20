import 'dart:async';
import 'package:tick_tick/models/user.dart';

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

    // Simulate valid login
    if (email == 'test@example.com' && password == 'password') {
      return const User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        avatar: null,
      );
    }

    // For demo, any email with valid format and password >= 6 chars will work
    if (email.contains('@') && email.contains('.')) {
      return User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: email.split('@')[0].toUpperCase(),
        avatar: null,
      );
    }

    throw Exception('Invalid email or password');
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
