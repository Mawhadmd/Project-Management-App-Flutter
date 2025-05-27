import 'package:finalmobileproject/services/ProjectService.dart';
import 'package:finalmobileproject/widgets/top_bar.dart';
import 'package:finalmobileproject/utils/decimal_to_alpha_colors.dart';
import 'package:flutter/material.dart';
import 'package:finalmobileproject/services/TasksService.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.changeTab});
  final Function(int) changeTab;
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'No date';
    final date = DateTime.parse(dateString);
    return DateFormat('MMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Topbar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Statistics
                  Row(
                    children: [
                      FutureBuilder(
                        future: ProjectService().getCompletedProjects(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildStatCard(
                              'Completed',
                              '0',
                              Colors.green,
                              Icons.check_circle_outline,
                            );
                          }
                          if (snapshot.hasError) {
                            return _buildStatCard(
                              'Completed',
                              '-1',
                              Colors.green,
                              Icons.check_circle_outline,
                            );
                          }
                          final projects = snapshot.data as List<dynamic>;
                          return _buildStatCard(
                            'Completed',
                            projects.length.toString(),
                            Colors.green,
                            Icons.check_circle_outline,
                          );
                        },
                      ),

                      const SizedBox(width: 16),
                      FutureBuilder(
                        future: ProjectService().getInProgressProjects(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildStatCard(
                              'In Progress',
                              '0',
                              Colors.orange,
                              Icons.pending_actions_outlined,
                            );
                          }
                          if (snapshot.hasError) {
                            return _buildStatCard(
                              'In Progress',
                              '-1',
                              Colors.orange,
                              Icons.pending_actions_outlined,
                            );
                          }
                          final projects = snapshot.data as List<dynamic>;
                          return _buildStatCard(
                            'In Progress',
                            projects.length.toString(),
                            Colors.orange,
                            Icons.pending_actions_outlined,
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      FutureBuilder(
                        future: ProjectService().getOtherStatusProjects(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildStatCard(
                              'Pending',
                              '0',
                              Colors.red,
                              Icons.schedule_outlined,
                            );
                          }
                          if (snapshot.hasError) {
                            return _buildStatCard(
                              'Pending',
                              '-1',
                              Colors.red,
                              Icons.schedule_outlined,
                            );
                          }
                          final projects = snapshot.data as List<dynamic>;
                          return _buildStatCard(
                            'Pending',
                            projects.length.toString(),
                            Colors.red,
                            Icons.schedule_outlined,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // My Tasks Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => changeTab(2),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Task List
                  FutureBuilder(
                    future: Tasksservice().getUserTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final tasks = snapshot.data as List<dynamic>;
                      if (tasks.isEmpty) {
                        return const Center(child: Text('No tasks found'));
                      }

                      return Column(
                        children:
                            tasks.map((task) {
                              final priority =
                                  task['priority'] as String? ?? 'Medium';
                              final color = _getPriorityColor(priority);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildTaskItem(
                                  task['title'] as String,
                                  task['description'] as String,
                                  _formatDate(task['dueDate'] as String?),
                                  color,
                                ),
                              );
                            }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(
    String title,
    String description,
    String date,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(date, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
