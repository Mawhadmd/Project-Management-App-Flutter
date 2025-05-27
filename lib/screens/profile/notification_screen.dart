// Notifications Screen
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive notifications on your device'),
            value: false,
            onChanged: (_) => _comingSoon(context),
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            value: false,
            onChanged: (_) => _comingSoon(context),
          ),
          SwitchListTile(
            title: const Text('Task Reminders'),
            subtitle: const Text('Get reminded about upcoming tasks'),
            value: false,
            onChanged: (_) => _comingSoon(context),
          ),
          SwitchListTile(
            title: const Text('Project Updates'),
            subtitle: const Text('Receive updates about your projects'),
            value: false,
            onChanged: (_) => _comingSoon(context),
          ),
        ],
      ),
    );
  }
}
