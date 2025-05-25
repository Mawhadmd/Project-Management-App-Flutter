import 'package:finalmobileproject/utils/decimal_to_alpha_colors.dart';
import 'package:flutter/material.dart';
import 'package:finalmobileproject/services/TasksService.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback? onStatusChanged;

  const TaskCard({super.key, required this.task, this.onStatusChanged});

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task['title'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(
                      task['priority'] ?? 'Medium',
                    ).withAlpha(decimal_to_alpha_colors(0.1)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getPriorityColor(
                        task['priority'] ?? 'Medium',
                      ).withAlpha(decimal_to_alpha_colors(0.3)),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _getPriorityColor(
                            task['priority'] ?? 'Medium',
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task['priority'] ?? 'Medium',
                        style: TextStyle(
                          color: _getPriorityColor(
                            task['priority'] ?? 'Medium',
                          ),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (task['description'] != null &&
                task['description'].toString().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task['description'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                if (task['start_date'] != null) ...[
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(task['start_date']),
                    style: TextStyle(fontSize: 10, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                ],
                if (task['due_date'] != null) ...[
                  Icon(Icons.event, size: 12, color: colorScheme.error),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(task['due_date']),
                    style: TextStyle(fontSize: 10, color: colorScheme.error),
                  ),
                ],
                const Spacer(),
                Transform.scale(
                  scale: 1.0,
                  child: Checkbox(
                    value: task['isDone'] ?? false,
                    onChanged: (bool? value) {
                      if (value != null) {
                        Tasksservice().setisDone(value, task['id']);
                        onStatusChanged?.call();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
