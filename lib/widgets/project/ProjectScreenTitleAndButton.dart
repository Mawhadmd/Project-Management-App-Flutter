import 'package:finalmobileproject/services/ProjectService.dart';
import 'package:finalmobileproject/models/project.class.dart';
import 'package:finalmobileproject/screens/projects/add_project_form.dart';
import 'package:flutter/material.dart';

class Newprojectbutton extends StatefulWidget {
  const Newprojectbutton({
    super.key,
    required this.searchphrase,
    required this.selectedStatus,
  });
  final searchphrase;
  final ProjectStatus? selectedStatus;
  @override
  State<Newprojectbutton> createState() => _NewprojectbuttonState();
}

class _NewprojectbuttonState extends State<Newprojectbutton> {
  @override
  Widget build(BuildContext context) {
    final projoctsnumber = FutureBuilder(
      future: ProjectService().getProjectsLength(
        widget.searchphrase,
        widget.selectedStatus,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "You have x projects",
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary.withAlpha(150),
            ),
          );
        }
        if (snapshot.hasData) {
          return Text(
            widget.searchphrase == ""
                ? "You have ${snapshot.data} projects"
                : "${snapshot.data} projects found",
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Theme.of(context).colorScheme.secondary.withAlpha(35),
              ),
            ),
            elevation: 1,
            shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }
}
