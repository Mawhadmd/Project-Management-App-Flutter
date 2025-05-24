import 'package:finalmobileproject/Database_Interactions/ProjectService.dart';
import 'package:finalmobileproject/types/project.class.dart';
import 'package:finalmobileproject/ui/screens/edit_project_form.dart';
import 'package:finalmobileproject/ui/screens/ProjectDetailsScreen/project_status_card.dart';
import 'package:finalmobileproject/ui/screens/ProjectDetailsScreen/project_description_card.dart';
import 'package:finalmobileproject/ui/screens/ProjectDetailsScreen/project_timeline_card.dart';
import 'package:finalmobileproject/ui/screens/ProjectDetailsScreen/project_tasks_card.dart';
import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late Project _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }

  Future<void> _editProject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProjectForm(project: _project),
      ),
    );

    if (result == true && mounted) {
      // Refresh project data
      final updatedProject = await ProjectService().getProject(_project.id);
      if (updatedProject != null && mounted) {
        setState(() {
          _project = updatedProject;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_project.name),
        actions: [
          IconButton(onPressed: _editProject, icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () async {
              // First confirmation
              final firstConfirm = await showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Project'),
                      content: Text(
                        'Are you sure you want to delete "${_project.name}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
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
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
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
                  _project.id,
                );
                if (result['status'] == 'Error') {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${result['details']}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Project deleted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context); // Return to projects screen
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectStatusCard(project: _project),
            const SizedBox(height: 24),
            ProjectDescriptionCard(description: _project.description),
            const SizedBox(height: 24),
            ProjectTimelineCard(
              startDate: _project.startDate,
              endDate: _project.endDate,
            ),
            const SizedBox(height: 24),
            ProjectTasksCard(projectId: _project.id),
          ],
        ),
      ),
    );
  }
}
