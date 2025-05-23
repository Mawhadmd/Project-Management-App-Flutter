import 'package:finalmobileproject/ui/Home/bottom_bar.dart';
import 'package:finalmobileproject/ui/project/project_title_and_button.dart';
import 'package:finalmobileproject/ui/project/projects_holder.dart';
import 'package:finalmobileproject/ui/Home/top_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              Topbar(),
              const SizedBox(height: 20),
              const Newprojectbutton(),
              const SizedBox(height: 20),
              const Expanded(child: Projectsholder()),
              BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
