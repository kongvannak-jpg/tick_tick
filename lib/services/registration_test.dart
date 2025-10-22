import 'dart:convert';
import 'package:http/http.dart' as http;

/// Test service to verify automatic registration works
class RegistrationTest {
  static const String _webAppUrl =
      'https://script.google.com/macros/s/AKfycby8Nf4-tNM8VpVLazhjHu2tudpsGnskuAs87KTRy1NSImy6aE1cTKM3_iFYPDJoKO__lg/exec';

  /// Test if the Apps Script Web App is responding
  static Future<void> testWebAppConnection() async {
    try {
      print('🧪 Testing Google Apps Script connection...');

      final response = await http.get(Uri.parse(_webAppUrl));

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Apps Script is responding!');
      } else {
        print('❌ Apps Script returned error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Failed to connect to Apps Script: $e');
    }
  }

  /// Test automatic user registration
  static Future<void> testUserRegistration() async {
    try {
      print('🧪 Testing automatic user registration...');

      // Create test user data
      final testUser = {
        'action': 'addUser',
        'data': {
          'id': 'test_${DateTime.now().millisecondsSinceEpoch}',
          'firstName': 'Test',
          'lastName': 'User',
          'email': 'test.user@example.com',
          'position': 'Tester',
          'createdAt': DateTime.now().toIso8601String(),
        },
      };

      print('📤 Sending test user data...');
      print('Data: ${jsonEncode(testUser)}');

      // Create HTTP client that follows redirects
      final client = http.Client();

      // Send POST request to Apps Script
      final response = await client.post(
        Uri.parse(_webAppUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(testUser),
      );

      print('📥 Response received:');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['success'] == true) {
            print('✅ TEST PASSED: User automatically added to Google Sheet!');
            print('✅ Message: ${responseData['message']}');
            print('✅ Check your Google Sheet for the test user!');
          } else {
            print('❌ TEST FAILED: ${responseData['message']}');
          }
        } catch (e) {
          print('⚠️ Response parsing error: $e');
          print('Raw response: ${response.body}');
        }
      } else if (response.statusCode == 302) {
        print('⚠️  Got redirect (302) - this is normal for Apps Script');
        print('📍 Redirect URL found in response');

        // Extract the redirect URL from the HTML response
        final redirectMatch = RegExp(
          r'HREF="([^"]+)"',
        ).firstMatch(response.body);
        if (redirectMatch != null) {
          final redirectUrl = redirectMatch.group(1)!.replaceAll('&amp;', '&');
          print(
            '🔗 Following redirect to: ${redirectUrl.substring(0, 100)}...',
          );

          // Follow the redirect
          final redirectResponse = await client.get(Uri.parse(redirectUrl));
          print('📥 Redirect response:');
          print('Status Code: ${redirectResponse.statusCode}');
          print('Response Body: ${redirectResponse.body}');

          if (redirectResponse.statusCode == 200) {
            try {
              final responseData = jsonDecode(redirectResponse.body);
              if (responseData['success'] == true) {
                print(
                  '✅ TEST PASSED: User automatically added to Google Sheet!',
                );
                print('✅ Message: ${responseData['message']}');
                print('✅ Check your Google Sheet for the test user!');
              } else {
                print('❌ TEST FAILED: ${responseData['message']}');
              }
            } catch (e) {
              print('⚠️ Redirect response parsing error: $e');
              print('Raw redirect response: ${redirectResponse.body}');
            }
          }
        }
      } else {
        print('❌ TEST FAILED: HTTP ${response.statusCode}');
        print('Response: ${response.body}');
      }

      client.close();
    } catch (e) {
      print('❌ Test failed with error: $e');
    }
  }

  /// Run all tests
  static Future<void> runAllTests() async {
    print('🚀 Starting Registration Tests...\n');

    await testWebAppConnection();
    print('\n' + '=' * 50 + '\n');
    await testUserRegistration();

    print('\n🎯 Test completed!');
    print('📊 Check your Google Sheet to see if test data appeared:');
    print(
      'https://docs.google.com/spreadsheets/d/1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs/edit',
    );
  }
}
