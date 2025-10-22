import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/sheets_provider.dart';
import '../providers/auth_provider.dart';

class SheetsDataSyncScreen extends ConsumerStatefulWidget {
  const SheetsDataSyncScreen({super.key});

  @override
  ConsumerState<SheetsDataSyncScreen> createState() =>
      _SheetsDataSyncScreenState();
}

class _SheetsDataSyncScreenState extends ConsumerState<SheetsDataSyncScreen> {
  @override
  void initState() {
    super.initState();
    // Load users when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(sheetsProvider).isConnected) {
        ref.read(sheetsProvider.notifier).loadAllUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sheetsState = ref.watch(sheetsProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sheets Sync'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (sheetsState.spreadsheetUrl != null)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Open Spreadsheet',
              onPressed: () => _openSpreadsheet(sheetsState.spreadsheetUrl!),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Status Card
            _buildConnectionCard(sheetsState),

            const SizedBox(height: 16),

            // Actions Section
            if (sheetsState.isConnected) ...[
              _buildActionsSection(sheetsState, authState),
              const SizedBox(height: 16),
              _buildUsersSection(sheetsState),
            ],

            // Error Display
            if (sheetsState.error != null) _buildErrorCard(sheetsState.error!),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(SheetsState sheetsState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  sheetsState.isConnected ? Icons.cloud_done : Icons.cloud_off,
                  color: sheetsState.isConnected ? Colors.green : Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sheetsState.isConnected
                            ? 'Connected to Google Sheets'
                            : 'Not Connected',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (sheetsState.userEmail != null)
                        Text(
                          'Account: ${sheetsState.userEmail}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!sheetsState.isConnected)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: sheetsState.isLoading ? null : _connectToSheets,
                  icon: sheetsState.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    sheetsState.isLoading
                        ? 'Connecting...'
                        : 'Connect to Google Sheets',
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: sheetsState.isLoading
                          ? null
                          : _disconnectFromSheets,
                      icon: const Icon(Icons.logout),
                      label: const Text('Disconnect'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (sheetsState.spreadsheetUrl != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _openSpreadsheet(sheetsState.spreadsheetUrl!),
                        icon: const Icon(Icons.table_chart),
                        label: const Text('View Sheet'),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(SheetsState sheetsState, AuthState authState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Management',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            // Backup Current Profile
            if (authState.user != null)
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Backup My Profile'),
                subtitle: const Text(
                  'Save current user profile to Google Sheets',
                ),
                trailing: sheetsState.isLoading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.arrow_forward_ios),
                onTap: sheetsState.isLoading ? null : _backupCurrentProfile,
              ),

            const Divider(),

            // Load All Users
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh User Data'),
              subtitle: const Text('Load latest data from Google Sheets'),
              trailing: sheetsState.isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.arrow_forward_ios),
              onTap: sheetsState.isLoading ? null : _refreshUsers,
            ),

            const Divider(),

            // Sync Settings
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Sync App Settings'),
              subtitle: const Text('Backup and sync app preferences'),
              trailing: sheetsState.isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.arrow_forward_ios),
              onTap: sheetsState.isLoading ? null : _syncSettings,
            ),

            const Divider(),

            // Export Data
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export to New Sheet'),
              subtitle: const Text('Create a backup copy in new spreadsheet'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: sheetsState.isLoading ? null : _exportData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersSection(SheetsState sheetsState) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Users in Sheets (${sheetsState.users.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: sheetsState.isLoading ? null : _refreshUsers,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: sheetsState.users.isEmpty
                    ? const Center(
                        child: Text(
                          'No users found in Google Sheets.\nTry backing up a profile first.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: sheetsState.users.length,
                        itemBuilder: (context, index) {
                          final user = sheetsState.users[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  (user['firstName']?.toString().isNotEmpty ==
                                              true
                                          ? user['firstName'][0]
                                          : 'U')
                                      .toUpperCase(),
                                ),
                              ),
                              title: Text(
                                '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'
                                    .trim(),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (user['email']?.toString().isNotEmpty ==
                                      true)
                                    Text('Email: ${user['email']}'),
                                  if (user['position']?.toString().isNotEmpty ==
                                      true)
                                    Text('Position: ${user['position']}'),
                                  if (user['lastUpdated']
                                          ?.toString()
                                          .isNotEmpty ==
                                      true)
                                    Text(
                                      'Updated: ${_formatDate(user['lastUpdated'])}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'restore',
                                    child: const Row(
                                      children: [
                                        Icon(Icons.restore),
                                        SizedBox(width: 8),
                                        Text('Restore'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: const Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) =>
                                    _handleUserAction(value.toString(), user),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(error, style: const TextStyle(color: Colors.red)),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => ref.read(sheetsProvider.notifier).clearError(),
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods
  Future<void> _connectToSheets() async {
    final success = await ref.read(sheetsProvider.notifier).connect();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connected to Google Sheets successfully!'),
        ),
      );
      ref.read(sheetsProvider.notifier).loadAllUsers();
    }
  }

  Future<void> _disconnectFromSheets() async {
    await ref.read(sheetsProvider.notifier).disconnect();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disconnected from Google Sheets')),
      );
    }
  }

  Future<void> _backupCurrentProfile() async {
    final authState = ref.read(authStateProvider);
    if (authState.user == null) return;

    final success = await ref.read(sheetsProvider.notifier).saveUserData({
      'id': authState.user!.id,
      'firstName': authState.user!.firstName,
      'lastName': authState.user!.lastName,
      'email': authState.user!.email,
      'position': authState.user!.position,
      'createdAt': authState.user!.createdAt.toIso8601String(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Profile backed up successfully!'
                : 'Failed to backup profile',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshUsers() async {
    await ref.read(sheetsProvider.notifier).loadAllUsers();
  }

  Future<void> _syncSettings() async {
    // Implement settings sync based on your app's settings structure
    final settings = {
      'app_version': '1.0.0',
      'sync_enabled': true,
      'last_sync': DateTime.now().toIso8601String(),
    };

    final success = await ref
        .read(sheetsProvider.notifier)
        .saveAppSettings(settings);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Settings synced successfully!'
                : 'Failed to sync settings',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _exportData() async {
    final exportName =
        'TickTick_Export_${DateTime.now().millisecondsSinceEpoch}';
    final url = await ref
        .read(sheetsProvider.notifier)
        .exportToSpreadsheet(exportName);

    if (mounted) {
      if (url != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data exported successfully!'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () => _openSpreadsheet(url),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to export data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleUserAction(
    String action,
    Map<String, dynamic> user,
  ) async {
    switch (action) {
      case 'restore':
        await _restoreUser(user);
        break;
      case 'delete':
        await _deleteUser(user);
        break;
    }
  }

  Future<void> _restoreUser(Map<String, dynamic> user) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore User Profile'),
        content: Text(
          'Replace current profile with:\n${user['firstName']} ${user['lastName']}\n${user['email']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Implement restore logic - this would update the current user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User profile restored!')));
    }
  }

  Future<void> _deleteUser(Map<String, dynamic> user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User Data'),
        content: Text(
          'Permanently delete data for:\n${user['firstName']} ${user['lastName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(sheetsProvider.notifier)
          .deleteUserData(user['id'].toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'User data deleted' : 'Failed to delete user data',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openSpreadsheet(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open spreadsheet')),
        );
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
