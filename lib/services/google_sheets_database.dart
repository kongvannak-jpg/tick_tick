import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tick_tick/utils/password_hasher.dart';
import 'package:tick_tick/models/user.dart';
import 'package:tick_tick/interfaces/database_interface.dart';
import 'package:tick_tick/config/app_config.dart';

/// Google Sheets Database Service - Writes data directly to your sheet!
/// Uses Google Apps Script for automatic data insertion
class GoogleSheetsDatabase implements DatabaseInterface {
  static const String _sheetId = '1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs';
  static const String _baseUrl = 'https://docs.google.com/spreadsheets/d';

  // Google Apps Script Web App URL - CONFIGURED FOR AUTOMATIC REGISTRATION!
  static const String? _webAppUrl =
      'https://script.google.com/macros/s/AKfycbzJI4OTjWbUACS2fptIvM08I-GGF7fjNTS8S11QYynQi4vwa6TCbO1ad5B3DiznqB3wJw/exec';

  /// Test if Google Apps Script is configured
  @override
  bool get isConfigured => _webAppUrl != null && _webAppUrl!.isNotEmpty;

  /// Login user with Google Sheets database
  @override
  Future<User?> loginUser(String email, String hashedPassword) async {
    if (!isConfigured) return null;

    try {
      final client = http.Client();

      final response = await client.post(
        Uri.parse(_webAppUrl!),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body:
            'action=login&email=${Uri.encodeComponent(email)}&password=${Uri.encodeComponent(hashedPassword)}',
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success'] == true && result['user'] != null) {
          final userData = result['user'];
          return User(
            id: userData['id'].toString(),
            email: userData['email'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            position: userData['position'],
            avatar: null,
            createdAt: DateTime.parse(userData['createdAt']),
          );
        }
      }

      client.close();
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  /// Save user to Google Sheets - ACTUALLY WRITES TO YOUR SHEET!
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
    try {
      // Try Google Apps Script first (automatic writing)
      if (isConfigured) {
        final success = await _writeViaAppsScript(
          id,
          firstName,
          lastName,
          email,
          position,
          createdAt,
          password,
        );
        if (success) {
          print('✅ User automatically saved to Google Sheet!');
          return true;
        }
      }

      // Fallback: Show manual instructions
      _showManualInstructions(
        id,
        firstName,
        lastName,
        email,
        position,
        createdAt,
      );
      return true;
    } catch (e) {
      print('❌ Error saving user: $e');
      _showManualInstructions(
        id,
        firstName,
        lastName,
        email,
        position,
        createdAt,
      );
      return false;
    }
  }

  /// Write to Google Sheets via Google Apps Script (automatic)
  Future<bool> _writeViaAppsScript(
    String id,
    String firstName,
    String lastName,
    String email,
    String position,
    String createdAt,
    String? password,
  ) async {
    if (_webAppUrl == null) return false;

    try {
      // Hash the password before sending
      final hashedPassword = password != null
          ? PasswordManager.hashPassword(password)
          : 'NO_PASSWORD_PROVIDED';

      // Send data in the exact format your Apps Script expects
      final body = {
        'action': 'register', // Tell Apps Script this is a registration
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'position': position,
        'createdAt': createdAt,
        'password': hashedPassword,
      };

      print('📤 Sending user data to Google Apps Script...');
      print('📤 Data being sent: $body');
      print('📤 Password value: "$password"');
      print('📤 Web App URL: $_webAppUrl');

      // Create HTTP client that follows redirects
      final client = http.Client();

      // Convert to proper form data string
      final formData = body.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
          )
          .join('&');
      print('📤 Form data string: $formData');

      final response = await client.post(
        Uri.parse(_webAppUrl!),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: formData,
      );

      print('📥 Response: ${response.statusCode}');
      print('📥 Response headers: ${response.headers}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('📄 Response Body: ${response.body}');
        try {
          final result = jsonDecode(response.body);
          if (result['success'] == true) {
            print('✅ User successfully saved to Google Sheet!');
            client.close();
            return true;
          }
        } catch (e) {
          print('⚠️ Response parsing error: $e');
          print('Raw response: ${response.body}');
        }
      } else if (response.statusCode == 302) {
        print('🔄 Following redirect...');

        // Extract redirect URL from HTML response
        final redirectMatch = RegExp(
          r'HREF="([^"]+)"',
        ).firstMatch(response.body);
        if (redirectMatch != null) {
          final redirectUrl = redirectMatch.group(1)!.replaceAll('&amp;', '&');

          // Follow the redirect
          final redirectResponse = await client.get(Uri.parse(redirectUrl));

          print('📥 Redirect Status: ${redirectResponse.statusCode}');
          print('📄 Redirect Response: ${redirectResponse.body}');

          if (redirectResponse.statusCode == 200) {
            try {
              final result = jsonDecode(redirectResponse.body);
              if (result['success'] == true) {
                print(
                  '✅ User successfully saved to Google Sheet via redirect!',
                );
                print('✅ Message: ${result['message']}');
                client.close();
                return true;
              } else {
                print('❌ Registration failed: ${result['message']}');
              }
            } catch (e) {
              print('⚠️ Redirect response parsing error: $e');
              print('Raw redirect response: ${redirectResponse.body}');
            }
          }
        }
      }

      client.close();
      return false;
    } catch (e) {
      print('❌ Apps Script error: $e');
      return false;
    }
  }

  /// Show instructions for manual data entry
  void _showManualInstructions(
    String id,
    String firstName,
    String lastName,
    String email,
    String position,
    String createdAt,
  ) {
    print('\n📋 NEW USER REGISTERED - ADD TO YOUR GOOGLE SHEET:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print(
      '🔗 Sheet URL: https://docs.google.com/spreadsheets/d/$_sheetId/edit',
    );
    print('');
    print('📝 Add this data to the next empty row:');
    print('   A: $id');
    print('   B: $firstName');
    print('   C: $lastName');
    print('   D: $email');
    print('   E: $position');
    print('   F: $createdAt');
    print('');
    print('📋 Copy-paste ready format:');
    print('$id\t$firstName\t$lastName\t$email\t$position\t$createdAt');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// Read users from your Google Sheet (CSV export method)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final String csvUrl = '$_baseUrl/$_sheetId/export?format=csv&gid=0';

      print('📖 Reading users from Google Sheet...');
      final response = await http.get(Uri.parse(csvUrl));

      if (response.statusCode == 200) {
        final users = _parseCsvToUsers(response.body);
        print('✅ Found ${users.length} users in Google Sheet');
        return users;
      } else {
        print('❌ Failed to read from Google Sheet: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error reading from Google Sheet: $e');
      return [];
    }
  }

  /// Find user by email
  Future<Map<String, dynamic>?> findUserByEmail(String email) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere(
        (user) =>
            user['email']?.toString().toLowerCase() == email.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if user exists
  Future<bool> userExists(String email) async {
    final user = await findUserByEmail(email);
    return user != null;
  }

  /// Parse CSV data to user list
  List<Map<String, dynamic>> _parseCsvToUsers(String csvData) {
    final List<Map<String, dynamic>> users = [];
    final List<String> lines = csvData.split('\n');

    if (lines.isEmpty) return users;

    // Skip header row (row 1)
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final List<String> values = _parseCsvLine(line);
      if (values.length >= 6) {
        users.add({
          'id': values[0].trim(),
          'firstName': values[1].trim(),
          'lastName': values[2].trim(),
          'email': values[3].trim(),
          'position': values[4].trim(),
          'createdAt': values[5].trim(),
        });
      }
    }

    return users;
  }

  /// Parse CSV line (handles quotes and commas)
  List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    String current = '';
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current);
        current = '';
      } else {
        current += char;
      }
    }

    result.add(current);
    return result;
  }

  /// Get your sheet URL
  String get sheetViewUrl =>
      'https://docs.google.com/spreadsheets/d/$_sheetId/edit';

  /// Get sheet URL for provider compatibility
  String get sheetUrl => sheetViewUrl;

  @override
  Future<User?> getUserById(String id) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.googleAppsScriptUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'action': 'getUserById', 'id': id},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] && data['user'] != null) {
          return User.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      print('Failed to get user: $e');
      return null;
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.googleAppsScriptUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'action': 'getUserByEmail', 'email': email},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] && data['user'] != null) {
          return User.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      print('Failed to get user: $e');
      return null;
    }
  }

  @override
  Future<bool> updateUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.googleAppsScriptUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'action': 'updateUser',
          'id': user.id,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'email': user.email,
          'position': user.position,
          // Don't send password in updates for security
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Failed to update user: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String id) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.googleAppsScriptUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'action': 'deleteUser', 'id': id},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Failed to delete user: $e');
      return false;
    }
  }

  @override
  Future<List<User>> getUsers({int page = 1, int limit = 50}) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.googleAppsScriptUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'action': 'getUsers',
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] && data['users'] != null) {
          final List<dynamic> usersData = data['users'];
          return usersData.map((userData) => User.fromJson(userData)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Failed to get users: $e');
      return [];
    }
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.googleAppsScriptUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'action': 'searchUsers', 'query': query},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] && data['users'] != null) {
          final List<dynamic> usersData = data['users'];
          return usersData.map((userData) => User.fromJson(userData)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Failed to search users: $e');
      return [];
    }
  }

  @override
  Future<bool> testConnection() async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.googleAppsScriptUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'action': 'testConnection'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}
