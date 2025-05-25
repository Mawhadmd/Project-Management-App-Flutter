

enum TasksStatus {
  notStarted,
  inProgress,
  completed,
  onHold,
  cancelled,
}
enum TaskPriority {
 low,
 medium,
 high,
}

class Tasks {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String dueDate;
  final String priority;
  final String projectID;
  final bool isDone;
  final List<String> collaborators;
  final TasksStatus status;

  Tasks({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.priority,
    required this.projectID,
    required this.isDone,
    required this.collaborators,
    required this.dueDate,
    this.status = TasksStatus.notStarted,
  });


}