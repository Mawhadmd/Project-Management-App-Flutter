import 'package:flutter/material.dart';
import 'package:finalmobileproject/services/TasksService.dart';
import 'package:finalmobileproject/widgets/task_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = '';

   filterTasks( tasks) {
    return tasks.where((task) {
      final matchesSearch =
          task['title'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          task['description'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesSearch;
    }).toList();
  }

  getUrgentTasks( tasks) {
    return tasks.where((task) {
      // A task is urgent if:
      // 1. It's high priority OR
      // 2. It has a due date within 2 days
      final isHighPriority = task['priority'] == 'High';
      final hasDueDate = task['due_date'] != null;

      if (hasDueDate) {
        final dueDate = DateTime.parse(task['due_date']);
        final now = DateTime.now();
        final daysUntilDue = dueDate.difference(now).inDays;
        final isOverdue = dueDate.isBefore(now);
        return isHighPriority || daysUntilDue <= 2 || isOverdue;
      }

      return isHighPriority;
    }).toList();
  }

  List<Map<String, dynamic>> _getOtherTasks(List<Map<String, dynamic>> tasks) {
    final urgentTasks = getUrgentTasks(tasks);
    return tasks.where((task) => !urgentTasks.contains(task)).toList()
      ..sort((a, b) {
        // First sort by priority
        final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
        final priorityA = priorityOrder[a['priority'] ?? 'Medium'] ?? 1;
        final priorityB = priorityOrder[b['priority'] ?? 'Medium'] ?? 1;
        if (priorityA != priorityB) return priorityA.compareTo(priorityB);

        // Then sort by due date
        if (a['due_date'] != null && b['due_date'] != null) {
          return DateTime.parse(
            a['due_date'],
          ).compareTo(DateTime.parse(b['due_date']));
        }
        if (a['due_date'] != null) return -1;
        if (b['due_date'] != null) return 1;
        return 0;
      });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Tasks',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 24),

        // Search Section
        TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline.withAlpha(50)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline.withAlpha(50)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Tasks List
        Expanded(
          child: StreamBuilder(
            stream: Supabase.instance.client
                .from('Tasks')
                .stream(primaryKey: ['id'])
                .eq(
                  'owner',
                  Supabase.instance.client.auth.currentUser?.id as String,
                ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading tasks',
                    style: TextStyle(color: colorScheme.error),
                  ),
                );
              }

              final tasks = snapshot.data ?? [];
              final filteredTasks = filterTasks(tasks);
              final urgentTasks = getUrgentTasks(filteredTasks);
              final otherTasks = _getOtherTasks(filteredTasks);

              if (filteredTasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 64,
                        color: colorScheme.primary.withAlpha(128),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks found',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                children: [
                  if (urgentTasks.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Urgent Tasks',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...urgentTasks.map(
                      (task) => TaskCard(
                        task: task,
                        onStatusChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (otherTasks.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Other Tasks',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...otherTasks.map(
                      (task) => TaskCard(
                        task: task,
                        onStatusChanged: () => setState(() {}),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
