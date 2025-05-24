

enum TasksStatus {
  notStarted,
  inProgress,
  completed,
  onHold,
  cancelled,
}

class Tasks {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String dueDate;
  final List<String> collaborators;
  final TasksStatus status;

  Tasks({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.collaborators,
    required this.dueDate,
    this.status = TasksStatus.notStarted,
  });


}