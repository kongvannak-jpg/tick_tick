import 'package:http/http.dart' as http;

/// Test class to verify Google Sheets access
class GoogleSheetsTest {
  static const String _sheetId = '1byf8ziMm5HGV5QyJ0m8FABbmqafC6QGjb5YMUb1DAEs';
  static const String _baseUrl = 'https://docs.google.com/spreadsheets/d';

  /// Test reading from your Google Sheet
  static Future<void> testSheetAccess() async {
    try {
      final String csvUrl = '$_baseUrl/$_sheetId/export?format=csv&gid=0';
      print('🔍 Testing access to: $csvUrl');

      final response = await http.get(Uri.parse(csvUrl));

      print('📊 Response Status: ${response.statusCode}');
      print('📊 Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        print('✅ SUCCESS: Can read your Google Sheet!');
        print('📋 Sheet Content:');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        print(response.body);
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

        // Parse the data
        final users = _parseCSV(response.body);
        print('👥 Found ${users.length} users in sheet');

        for (var user in users) {
          print(
            'User: ${user['firstName']} ${user['lastName']} (${user['email']})',
          );
        }
      } else {
        print('❌ ERROR: Cannot access your Google Sheet');
        print('Status: ${response.statusCode}');
        print('Body: ${response.body}');
      }
    } catch (e) {
      print('💥 EXCEPTION: $e');
    }
  }

  /// Parse CSV data
  static List<Map<String, dynamic>> _parseCSV(String csvData) {
    final List<Map<String, dynamic>> users = [];
    final List<String> lines = csvData.split('\n');

    if (lines.isEmpty) return users;

    // Skip header row
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final List<String> values = line.split(',');
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

  /// Test adding sample data (shows what would be added)
  static void testSampleData() {
    print('\n🧪 SAMPLE USER DATA FOR TESTING:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final sampleUser = {
      'id': 'test_${DateTime.now().millisecondsSinceEpoch}',
      'firstName': 'Test',
      'lastName': 'User',
      'email': 'test@example.com',
      'position': 'Tester',
      'createdAt': DateTime.now().toIso8601String(),
    };

    print('Sample User Data:');
    print('ID: ${sampleUser['id']}');
    print('Name: ${sampleUser['firstName']} ${sampleUser['lastName']}');
    print('Email: ${sampleUser['email']}');
    print('Position: ${sampleUser['position']}');
    print('Created: ${sampleUser['createdAt']}');
    print('');
    print('📋 Copy-paste format for your sheet:');
    print(
      '${sampleUser['id']}\t${sampleUser['firstName']}\t${sampleUser['lastName']}\t${sampleUser['email']}\t${sampleUser['position']}\t${sampleUser['createdAt']}',
    );
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
