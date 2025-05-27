import 'package:flutter/material.dart';
import 'package:finalmobileproject/services/TasksService.dart';
import 'package:finalmobileproject/widgets/tasks/task_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = '';

  filterTasks(tasks) {
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

  getUrgentTasks(tasks) {
    return tasks.where((task) {
      final isHighPriority = task['priority'] == 'High';
      final hasDueDate = task['due_date'] != null;
      final isNotCompleted = task['isDone'] != true;

      if (hasDueDate && isNotCompleted) {
        final dueDate = DateTime.parse(task['due_date']);
        final now = DateTime.now();
        final daysUntilDue = dueDate.difference(now).inDays;
        final isOverdue = dueDate.isBefore(now);
        return isHighPriority || daysUntilDue <= 2 || isOverdue;
      }

      return isHighPriority && isNotCompleted;
    }).toList();
  }

  List<Map<String, dynamic>> _getOtherTasks(List<Map<String, dynamic>> tasks) {
    final urgentTasks = getUrgentTasks(tasks);
    final completedTasks =
        tasks.where((task) => task['isDone'] == true).toList();

    return tasks
        .where(
          (task) =>
              !urgentTasks.contains(task) && !completedTasks.contains(task),
        )
        .toList()
      ..sort((a, b) {
        final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
        final priorityA = priorityOrder[a['priority'] ?? 'Medium'] ?? 1;
        final priorityB = priorityOrder[b['priority'] ?? 'Medium'] ?? 1;
        if (priorityA != priorityB) return priorityA.compareTo(priorityB);

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

  List<Map<String, dynamic>> _getCompletedTasks(
    List<Map<String, dynamic>> tasks,
  ) {
    return tasks.where((task) => task['isDone'] == true).toList()..sort((a, b) {
      // Sort completed tasks by completion date (most recent first)
      if (a['completed_at'] != null && b['completed_at'] != null) {
        return DateTime.parse(
          b['completed_at'],
        ).compareTo(DateTime.parse(a['completed_at']));
      }
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Tasks',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // TODO: Implement task filtering
                },
                icon: Icon(Icons.filter_list, color: colorScheme.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Search Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
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
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary),
              ),
              filled: true,
              fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
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
              final completedTasks = _getCompletedTasks(filteredTasks);

              if (filteredTasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 64,
                        color: colorScheme.primary.withOpacity(0.5),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (urgentTasks.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            size: 20,
                            color: colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Urgent Tasks',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.task_alt_rounded,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Other Tasks',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...otherTasks.map(
                      (task) => TaskCard(
                        task: task,
                        onStatusChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (completedTasks.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Completed Tasks',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...completedTasks.map(
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
