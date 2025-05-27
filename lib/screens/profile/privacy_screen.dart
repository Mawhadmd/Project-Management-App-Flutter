
// Privacy Screen
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPrivacySection(context, 'Account Privacy', [
            SwitchListTile(
              title: const Text('Public Profile'),
              subtitle: const Text('Allow others to view your profile'),
              value: false,
              onChanged: (value) {
                // Handle public profile toggle
              },
            ),
            SwitchListTile(
              title: const Text('Show Activity Status'),
              subtitle: const Text('Show when you are active'),
              value: true,
              onChanged: (value) {
                // Handle activity status toggle
              },
            ),
          ]),
          const SizedBox(height: 16),
          _buildPrivacySection(context, 'Data & Privacy', [
            ListTile(
              title: const Text('Download My Data'),
              trailing: const Icon(Icons.download),
              onTap: () {
                // Handle download data
              },
            ),
            ListTile(
              title: const Text('Delete Account'),
              trailing: const Icon(Icons.delete, color: Colors.red),
              onTap: () {
                // Handle delete account
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(child: Column(children: children)),
      ],
    );
  }
}
