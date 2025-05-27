
// Help & Support Screen
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSupportCard(
            context,
            'FAQs',
            'Find answers to frequently asked questions',
            Icons.question_answer,
            () {
              // Navigate to FAQs
            },
          ),
          _buildSupportCard(
            context,
            'Contact Support',
            'Get in touch with our support team',
            Icons.support_agent,
            () {
              // Navigate to contact support
            },
          ),
          _buildSupportCard(
            context,
            'Report a Problem',
            'Let us know if you encounter any issues',
            Icons.bug_report,
            () {
              // Navigate to report problem
            },
          ),
          _buildSupportCard(
            context,
            'User Guide',
            'Learn how to use the app effectively',
            Icons.menu_book,
            () {
              // Navigate to user guide
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
