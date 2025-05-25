import 'package:finalmobileproject/widgets/bottom_bar.dart';

import 'package:finalmobileproject/screens/home/dashboard_screen.dart';

import 'package:finalmobileproject/screens/profile/profile_screen.dart';
import 'package:finalmobileproject/screens/projects/projects_screen.dart';
import 'package:finalmobileproject/screens/tasks/tasks_screen.dart';
import 'package:finalmobileproject/screens/teams/teams_screen.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Widget> _screens;
  int _selectedIndex = 1; // Start with Projects tab selected
  void changeBottomBarIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardScreen(),
      const Projectsscreen(),
      const TasksScreen(),
      const TeamsScreen(),
      ProfileScreen(changeTab: changeBottomBarIndex),
    ];
  }

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
