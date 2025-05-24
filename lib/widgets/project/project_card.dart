import 'package:finalmobileproject/services/ProjectService.dart';
import 'package:finalmobileproject/models/project.class.dart';
import 'package:finalmobileproject/screens/projects/edit_project_form.dart';

import 'package:finalmobileproject/screens/projects/project_details_screen.dart';
import 'package:flutter/material.dart';

class Projectcard extends StatelessWidget {
  const Projectcard({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProjectDetailsScreen(project: project),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(14, 14, 14, 100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      project.status.name == "completed"
                          ? "Completed"
                          : project.status.name == "inProgress"
                          ? "In Progress"
                          : project.status.name == "onHold"
                          ? "On Hold"
                          : project.status.name == "cancelled"
                          ? "Cancelled"
                          : "Not Started",
                      style: TextStyle(
                        color:
                            project.status.name == "completed"
                                ? Colors.green.shade700
                                : project.status.name == "inProgress"
                                ? Colors.orange.shade700
                                : project.status.name == "onHold"
                                ? Colors.blue.shade700
                                : project.status.name == "cancelled"
                                ? Colors.red.shade700
                                : const Color.fromRGBO(9, 9, 9, 100),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EditProjectForm(project: project),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          // First confirmation
                          final firstConfirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Delete Project'),
                                  content: Text(
                                    'Are you sure you want to delete "${project.name}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                          );

                          if (firstConfirm != true || !context.mounted) return;

                          // Second confirmation
                          final secondConfirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text(
                                    'This action cannot be undone. Are you Utterly sure?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('Yes, Delete'),
                                    ),
                                  ],
                                ),
                          );

                          if (secondConfirm != true || !context.mounted) return;

                          try {
                            final result = await ProjectService().deleteProject(
                              project.id,
                            );
                            if (result['status'] == 'Error') {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error: ${result['details']}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Project deleted successfully',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error deleting project: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                project.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Due ${project.endDate}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
