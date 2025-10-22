import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tick_tick/models/user.dart';
import 'package:tick_tick/services/auth_service.dart';
import 'package:tick_tick/services/google_sheets_database.dart';

// Auth state model
class AuthState {
  final bool isLoggedIn;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isLoggedIn = false,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Auth notifier
class AuthNotifier extends Notifier<AuthState> {
  final AuthService _authService = AuthService();
  final GoogleSheetsDatabase _sheetsDb = GoogleSheetsDatabase();

  @override
  AuthState build() => const AuthState();

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.login(email, password);
      state = state.copyWith(isLoggedIn: true, user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String position,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        position: position,
      );

      // Save user data to your Google Sheet
      await _sheetsDb.saveUser(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        position: user.position,
        createdAt: user.createdAt.toIso8601String(),
        password: password, // Add password to Google Sheets
      );

      state = state.copyWith(isLoading: false, isLoggedIn: true, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
