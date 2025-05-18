import 'package:finalmobileproject/NewProjectButton.dart';
import 'package:finalmobileproject/Projectcard.dart';
import 'package:finalmobileproject/ProjectsHolder.dart';
import 'package:finalmobileproject/TopBar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Topbar(),
              const SizedBox(height: 20),

              Newprojectbutton(),

              const SizedBox(height: 20),

              // Project card
              Projectsholder(),
            ],
          ),
        ),
      ),
    );
  }
}
