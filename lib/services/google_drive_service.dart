import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service for using Google Drive as a database for app data
class GoogleDriveStorageService {
  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/drive.file',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
  drive.DriveApi? _driveApi;
  String? _appFolderId;

  /// Initialize the service and connect to Google Drive
  Future<bool> initialize() async {
    try {
      // Try to sign in silently first
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      if (account == null) {
        // If silent sign-in fails, prompt user to sign in
        account = await _googleSignIn.signIn();
      }

      if (account != null) {
        await _initializeDriveApi(account);
        await _ensureAppFolder();
        await _saveConnectionStatus(true);
        return true;
      }
      return false;
    } catch (e) {
      print('Drive initialization failed: $e');
      return false;
    }
  }

  /// Initialize Drive API with authenticated client
  Future<void> _initializeDriveApi(GoogleSignInAccount account) async {
    final GoogleSignInAuthentication auth = await account.authentication;
    final AuthClient authClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          auth.accessToken!,
          DateTime.now().add(const Duration(hours: 1)),
        ),
        auth.idToken,
        _scopes,
      ),
    );
    _driveApi = drive.DriveApi(authClient);
  }

  /// Create or find the app's folder in Google Drive
  Future<void> _ensureAppFolder() async {
    if (_driveApi == null) return;

    try {
      // Search for existing app folder
      final drive.FileList folders = await _driveApi!.files.list(
        q: "name='TickTick_Data' and mimeType='application/vnd.google-apps.folder'",
      );

      if (folders.files?.isNotEmpty ?? false) {
        _appFolderId = folders.files!.first.id;
      } else {
        // Create app folder
        final drive.File folderMetadata = drive.File()
          ..name = 'TickTick_Data'
          ..mimeType = 'application/vnd.google-apps.folder';

        final drive.File folder = await _driveApi!.files.create(folderMetadata);
        _appFolderId = folder.id;
      }
    } catch (e) {
      print('Failed to setup app folder: $e');
    }
  }

  /// Save user data to Google Drive
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    if (_driveApi == null || _appFolderId == null) {
      print('Drive not initialized');
      return false;
    }

    try {
      final String fileName = 'user_${userData['id']}.json';
      final String jsonData = jsonEncode(userData);
      final List<int> fileContent = utf8.encode(jsonData);

      // Check if file exists
      final String? existingFileId = await _findFileId(fileName);

      if (existingFileId != null) {
        // Update existing file
        await _driveApi!.files.update(
          drive.File(),
          existingFileId,
          uploadMedia: drive.Media(
            Stream.fromIterable([fileContent]),
            fileContent.length,
          ),
        );
      } else {
        // Create new file
        final drive.File fileMetadata = drive.File()
          ..name = fileName
          ..parents = [_appFolderId!];

        await _driveApi!.files.create(
          fileMetadata,
          uploadMedia: drive.Media(
            Stream.fromIterable([fileContent]),
            fileContent.length,
          ),
        );
      }

      print('User data saved to Drive successfully');
      return true;
    } catch (e) {
      print('Failed to save user data: $e');
      return false;
    }
  }

  /// Load user data from Google Drive
  Future<Map<String, dynamic>?> loadUserData(String userId) async {
    if (_driveApi == null || _appFolderId == null) {
      print('Drive not initialized');
      return null;
    }

    try {
      final String fileName = 'user_$userId.json';
      final String? fileId = await _findFileId(fileName);

      if (fileId == null) {
        print('User data file not found');
        return null;
      }

      // Download file content
      final drive.Media media =
          await _driveApi!.files.get(
                fileId,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final List<int> dataBytes = [];
      await media.stream.forEach(dataBytes.addAll);
      final String jsonData = utf8.decode(dataBytes);

      print('User data loaded from Drive successfully');
      return jsonDecode(jsonData) as Map<String, dynamic>;
    } catch (e) {
      print('Failed to load user data: $e');
      return null;
    }
  }

  /// Save app settings to Google Drive
  Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    if (_driveApi == null || _appFolderId == null) return false;

    try {
      const String fileName = 'app_settings.json';
      final String jsonData = jsonEncode(settings);
      final List<int> fileContent = utf8.encode(jsonData);

      final String? existingFileId = await _findFileId(fileName);

      if (existingFileId != null) {
        await _driveApi!.files.update(
          drive.File(),
          existingFileId,
          uploadMedia: drive.Media(
            Stream.fromIterable([fileContent]),
            fileContent.length,
          ),
        );
      } else {
        final drive.File fileMetadata = drive.File()
          ..name = fileName
          ..parents = [_appFolderId!];

        await _driveApi!.files.create(
          fileMetadata,
          uploadMedia: drive.Media(
            Stream.fromIterable([fileContent]),
            fileContent.length,
          ),
        );
      }

      return true;
    } catch (e) {
      print('Failed to save app settings: $e');
      return false;
    }
  }

  /// Load app settings from Google Drive
  Future<Map<String, dynamic>?> loadAppSettings() async {
    if (_driveApi == null || _appFolderId == null) return null;

    try {
      const String fileName = 'app_settings.json';
      final String? fileId = await _findFileId(fileName);

      if (fileId == null) return null;

      final drive.Media media =
          await _driveApi!.files.get(
                fileId,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final List<int> dataBytes = [];
      await media.stream.forEach(dataBytes.addAll);
      final String jsonData = utf8.decode(dataBytes);

      return jsonDecode(jsonData) as Map<String, dynamic>;
    } catch (e) {
      print('Failed to load app settings: $e');
      return null;
    }
  }

  /// List all user data files in Google Drive
  Future<List<String>> getAllUserIds() async {
    if (_driveApi == null || _appFolderId == null) return [];

    try {
      final drive.FileList files = await _driveApi!.files.list(
        q: "'$_appFolderId' in parents and name contains 'user_'",
      );

      return files.files
              ?.map((file) {
                final String fileName = file.name ?? '';
                if (fileName.startsWith('user_') &&
                    fileName.endsWith('.json')) {
                  return fileName.substring(
                    5,
                    fileName.length - 5,
                  ); // Extract user ID
                }
                return '';
              })
              .where((id) => id.isNotEmpty)
              .toList() ??
          [];
    } catch (e) {
      print('Failed to get user list: $e');
      return [];
    }
  }

  /// Delete user data from Google Drive
  Future<bool> deleteUserData(String userId) async {
    if (_driveApi == null || _appFolderId == null) return false;

    try {
      final String fileName = 'user_$userId.json';
      final String? fileId = await _findFileId(fileName);

      if (fileId != null) {
        await _driveApi!.files.delete(fileId);
        print('User data deleted successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to delete user data: $e');
      return false;
    }
  }

  /// Find file ID by filename in app folder
  Future<String?> _findFileId(String fileName) async {
    if (_driveApi == null || _appFolderId == null) return null;

    try {
      final drive.FileList files = await _driveApi!.files.list(
        q: "'$_appFolderId' in parents and name='$fileName'",
      );

      return files.files?.isNotEmpty == true ? files.files!.first.id : null;
    } catch (e) {
      print('Failed to find file: $e');
      return null;
    }
  }

  /// Check if connected to Google Drive
  Future<bool> isConnected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('drive_connected') ?? false;
  }

  /// Save connection status
  Future<void> _saveConnectionStatus(bool connected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('drive_connected', connected);
  }

  /// Disconnect from Google Drive
  Future<void> disconnect() async {
    try {
      await _googleSignIn.signOut();
      _driveApi = null;
      _appFolderId = null;
      await _saveConnectionStatus(false);
    } catch (e) {
      print('Failed to disconnect: $e');
    }
  }

  /// Get current Google account info
  String? getCurrentUserEmail() {
    return _googleSignIn.currentUser?.email;
  }

  /// Backup all data (utility method)
  Future<bool> backupAllData(
    List<Map<String, dynamic>> allUsers,
    Map<String, dynamic> settings,
  ) async {
    try {
      // Save each user
      for (final userData in allUsers) {
        final success = await saveUserData(userData);
        if (!success) return false;
      }

      // Save settings
      await saveAppSettings(settings);

      print('Full backup completed successfully');
      return true;
    } catch (e) {
      print('Backup failed: $e');
      return false;
    }
  }
}
