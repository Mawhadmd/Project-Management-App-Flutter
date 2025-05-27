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
    final priorityColor = _getPriorityColor(task['priority'] ?? 'Medium');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: task['isDone'] ?? false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (bool? value) {
                      if (value != null) {
                        Tasksservice().setisDone(value, task['id']);
                        onStatusChanged?.call();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title'],
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          decoration:
                              task['isDone'] == true
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                      if (task['description'] != null &&
                          task['description'].toString().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task['description'],
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            decoration:
                                task['isDone'] == true
                                    ? TextDecoration.lineThrough
                                    : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ] else ...[
                        Text(
                          'No description',
                          style: TextStyle(color: Colors.grey.withAlpha(100)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: priorityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task['priority'] ?? 'Medium',
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (task['start_date'] != null || task['due_date'] != null)
                  Row(
                    children: [
                      if (task['start_date'] != null) ...[
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(task['start_date']),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                      if (task['start_date'] != null &&
                          task['due_date'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      if (task['due_date'] != null) ...[
                        Icon(Icons.event, size: 14, color: colorScheme.error),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(task['due_date']),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
