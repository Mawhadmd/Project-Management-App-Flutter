// Notifications Screen
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive notifications on your device'),
            value: true,
            onChanged: (value) {
              // Handle push notifications toggle
            },
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            value: true,
            onChanged: (value) {
              // Handle email notifications toggle
            },
          ),
          SwitchListTile(
            title: const Text('Task Reminders'),
            subtitle: const Text('Get reminded about upcoming tasks'),
            value: true,
            onChanged: (value) {
              // Handle task reminders toggle
            },
          ),
          SwitchListTile(
            title: const Text('Project Updates'),
            subtitle: const Text('Receive updates about your projects'),
            value: true,
            onChanged: (value) {
              // Handle project updates toggle
            },
          ),
        ],
      ),
    );
  }
}
