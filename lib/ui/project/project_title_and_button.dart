import 'package:finalmobileproject/ui/project/add_project_form.dart';
import 'package:flutter/material.dart';

class Newprojectbutton extends StatefulWidget {
  const Newprojectbutton({super.key});

  @override
  State<Newprojectbutton> createState() => _NewprojectbuttonState();
}

class _NewprojectbuttonState extends State<Newprojectbutton> {
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
            Text(
              "You have x projects",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary.withAlpha(150),
              ),
            ),
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
