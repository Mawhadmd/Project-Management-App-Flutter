import 'package:finalmobileproject/project_adding_button.dart';
import 'package:finalmobileproject/projects_holder.dart';
import 'package:finalmobileproject/top_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      
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
