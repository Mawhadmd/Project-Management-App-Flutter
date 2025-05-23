import 'package:finalmobileproject/Database_Interactions/ProjectService.dart';
import 'package:finalmobileproject/ui/project/add_project_form.dart';
import 'package:flutter/material.dart';

class Newprojectbutton extends StatefulWidget {
  const Newprojectbutton({super.key});

  @override
  State<Newprojectbutton> createState() => _NewprojectbuttonState();
}

class _NewprojectbuttonState extends State<Newprojectbutton> {
  final projoctsnumber = FutureBuilder(
    future: ProjectService().getProjectsLength(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasData) {
        return Text(
          "You have ${snapshot.data} projects",
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.secondary.withAlpha(150),
          ),
        );
      }
      return Text(
        'You have 0 projects',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.secondary.withAlpha(150),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Projects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            projoctsnumber,
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Addprojectform()),
            );
          },
          icon: const Icon(Icons.edit, size: 18),
          label: const Text(
            "New Project",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.secondary.withAlpha(255),
            foregroundColor: Theme.of(context).colorScheme.primary,
            iconColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }
}
