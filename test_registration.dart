import 'lib/services/registration_test.dart';

void main() async {
  print('🧪 TESTING AUTOMATIC REGISTRATION SYSTEM\n');

  await RegistrationTest.runAllTests();

  print('\n🔍 What to check next:');
  print('1. Look at the test output above');
  print('2. Check your Google Sheet for new test data');
  print('3. If successful, your registration system is working!');
}
