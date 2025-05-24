import 'package:finalmobileproject/util/status_utils.dart';
import 'package:flutter/material.dart';
import 'package:finalmobileproject/types/project.class.dart';

class ProjectStatusCard extends StatelessWidget {
  final Project project;

  const ProjectStatusCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(14, 14, 14, 100),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              getStatusText(project.status.name),
              style: TextStyle(
                color: getStatusColor(project.status.name),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
