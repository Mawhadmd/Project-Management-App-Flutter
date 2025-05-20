import 'package:finalmobileproject/Auth/AuthProvider.dart';
import 'package:flutter/material.dart';

class Usersettings extends StatelessWidget {
  const Usersettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement edit profile functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement change password functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement notification settings
              },
            ),
            const Divider(),
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: false, // TODO: Implement dark mode state
                onChanged: (bool value) {
                  // TODO: Implement dark mode toggle
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement language selection
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Authprovider().signOut();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
