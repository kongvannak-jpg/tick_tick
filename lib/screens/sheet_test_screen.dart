import 'package:flutter/material.dart';
import '../services/database_factory.dart';
import '../interfaces/database_interface.dart';
import '../models/user.dart';
import '../config/app_config.dart';

class SheetTestScreen extends StatefulWidget {
  const SheetTestScreen({super.key});

  @override
  State<SheetTestScreen> createState() => _SheetTestScreenState();
}

class _SheetTestScreenState extends State<SheetTestScreen> {
  late final DatabaseInterface _database;

  List<User> _users = [];
  bool _isLoading = false;
  String? _error;
  bool _connectionStatus = false;

  @override
  void initState() {
    super.initState();
    _database = DatabaseFactory.getInstance(type: DatabaseType.googleSheets);
    _testConnection();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Test connection first
      final connectionSuccess = await _database.testConnection();

      if (connectionSuccess) {
        // Try to load users
        final users = await _database.getUsers(limit: 10);
        setState(() {
          _users = users;
          _connectionStatus = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to connect to database';
          _connectionStatus = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Connection failed: $e';
        _connectionStatus = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _addTestUser() async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final testId = 'test_${DateTime.now().millisecondsSinceEpoch}';

      await _database.saveUser(
        id: testId,
        firstName: 'Test',
        lastName: 'User',
        email: 'test@example.com',
        position: 'Tester',
        createdAt: timestamp,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test user added successfully!')),
        );
      }
      _testConnection(); // Refresh the list
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sheet Connection Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _testConnection,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Testing Connection',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Backend: Google Sheets'),
                    const SizedBox(height: 4),
                    Text('Sheet ID: ${AppConfig.googleSheetId}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _connectionStatus ? Icons.check_circle : Icons.error,
                          color: _connectionStatus ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _connectionStatus ? 'Connected' : 'Disconnected',
                          style: TextStyle(
                            color: _connectionStatus
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Status
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: $_error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Success! Found ${_users.length} users',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Users List
            Text(
              'Users from Sheet:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            Expanded(
              child: _users.isEmpty
                  ? const Center(
                      child: Text(
                        'No users found.\nTry adding some data to your sheet.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(user.firstName[0].toUpperCase()),
                            ),
                            title: Text(user.name),
                            subtitle: Text('${user.email} • ${user.position}'),
                            trailing: Text(
                              '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_isLoading && _connectionStatus
          ? FloatingActionButton.extended(
              onPressed: _addTestUser,
              icon: const Icon(Icons.person_add),
              label: const Text('Add Test User'),
            )
          : null,
    );
  }
}
