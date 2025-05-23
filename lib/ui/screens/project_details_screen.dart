import 'package:finalmobileproject/Database_Interactions/ProjectService.dart';
import 'package:finalmobileproject/types/project.class.dart';
import 'package:finalmobileproject/ui/screens/edit_project_form.dart';
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
    final result = await Navigator.push<bool>(
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
              final firstConfirm = await showDialog<bool>(
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
            // Status and Estimate
            Container(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(14, 14, 14, 100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _project.status.name == "completed"
                          ? "Completed"
                          : _project.status.name == "inProgress"
                          ? "In Progress"
                          : _project.status.name == "onHold"
                          ? "On Hold"
                          : _project.status.name == "cancelled"
                          ? "Cancelled"
                          : "Not Started",
                      style: TextStyle(
                        color:
                            _project.status.name == "completed"
                                ? Colors.green.shade700
                                : _project.status.name == "inProgress"
                                ? Colors.orange.shade700
                                : _project.status.name == "onHold"
                                ? Colors.blue.shade700
                                : _project.status.name == "cancelled"
                                ? Colors.red.shade700
                                : const Color.fromRGBO(9, 9, 9, 100),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Est. ${_project.est}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
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
              child: Text(
                _project.description.isEmpty
                    ? 'No description provided'
                    : _project.description.trim(),
                style: TextStyle(
                  color:
                      _project.description.isEmpty
                          ? Colors.grey
                          : Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Timeline
            Text(
              'Timeline',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
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
                children: [
                  _buildTimelineItem(
                    context,
                    'Start Date',
                    _project.startDate,
                    Icons.calendar_today,
                  ),
                  const Divider(),
                  _buildTimelineItem(
                    context,
                    'End Date',
                    _project.endDate,
                    Icons.calendar_month,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String label,
    String date,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
