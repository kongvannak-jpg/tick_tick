import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tick_tick/services/google_sheets_database.dart';

/// State for Google Sheets connection and operations
class SheetsState {
  final bool isConnected;
  final bool isLoading;
  final String? error;
  final String? userEmail;
  final String? spreadsheetUrl;
  final List<Map<String, dynamic>> users;

  const SheetsState({
    this.isConnected = false,
    this.isLoading = false,
    this.error,
    this.userEmail,
    this.spreadsheetUrl,
    this.users = const [],
  });

  SheetsState copyWith({
    bool? isConnected,
    bool? isLoading,
    String? error,
    String? userEmail,
    String? spreadsheetUrl,
    List<Map<String, dynamic>>? users,
  }) {
    return SheetsState(
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      userEmail: userEmail ?? this.userEmail,
      spreadsheetUrl: spreadsheetUrl ?? this.spreadsheetUrl,
      users: users ?? this.users,
    );
  }
}

/// Notifier for Google Sheets operations - Connected to your specific sheet!
class SheetsNotifier extends Notifier<SheetsState> {
  final GoogleSheetsDatabase _database = GoogleSheetsDatabase();

  @override
  SheetsState build() {
    return const SheetsState(
      isConnected: true, // Always connected to your sheet
      userEmail: 'vannakkong85@gmail.com',
      spreadsheetUrl:
          'https://docs.google.com/spreadsheets/d/1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs/edit',
    );
  }

  /// Load all users from your Google Sheet
  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await _database.getAllUsers();
      state = state.copyWith(isLoading: false, users: users);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Save user to your Google Sheet
  Future<bool> saveUser(Map<String, dynamic> userData) async {
    try {
      final success = await _database.saveUser(
        id: userData['id'] ?? '',
        firstName: userData['firstName'] ?? '',
        lastName: userData['lastName'] ?? '',
        email: userData['email'] ?? '',
        position: userData['position'] ?? '',
        createdAt: userData['createdAt'] ?? DateTime.now().toIso8601String(),
      );

      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Clear errors
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Load all users (alias for loadUsers for compatibility)
  Future<void> loadAllUsers() async {
    await loadUsers();
  }

  /// Connect to Google Sheets (always connected, but for compatibility)
  Future<bool> connect() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final isConnected = await _database.testConnection();
      state = state.copyWith(isLoading: false, isConnected: isConnected);
      return isConnected;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isConnected: false,
      );
      return false;
    }
  }

  /// Disconnect (placeholder for compatibility)
  Future<void> disconnect() async {
    // For Google Sheets, we don't really disconnect, but update state
    state = state.copyWith(isConnected: false);
  }

  /// Save user data (alias for saveUser for compatibility)
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    return await saveUser(userData);
  }

  /// Delete user data
  Future<bool> deleteUserData(String userId) async {
    try {
      final success = await _database.deleteUser(userId);
      if (success) {
        // Reload users to reflect changes
        await loadUsers();
      }
      return success;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Save app settings (placeholder - can be extended)
  Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    try {
      // For now, just return success
      // In a real app, you might save settings to a separate sheet or storage
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Export to spreadsheet (placeholder - already in spreadsheet)
  Future<bool> exportToSpreadsheet(String exportName) async {
    try {
      // For Google Sheets, data is already in the spreadsheet
      // You could create a copy or formatted export here
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Get your sheet URL
  String get sheetUrl => _database.sheetUrl;
}

/// Provider for Google Sheets operations
final sheetsProvider = NotifierProvider<SheetsNotifier, SheetsState>(() {
  return SheetsNotifier();
});
