import 'package:finalmobileproject/ui/Home/bottom_bar.dart';

import 'package:finalmobileproject/ui/screens/dashboard_screen.dart';

import 'package:finalmobileproject/ui/screens/profile_screen.dart';
import 'package:finalmobileproject/ui/screens/projects_screen.dart';
import 'package:finalmobileproject/ui/screens/tasks_screen.dart';


import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Start with Projects tab selected

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ProjectsScreen(),
    const TasksScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 244, 246, 248),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Expanded(child: _screens[_selectedIndex]),
              BottomBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
