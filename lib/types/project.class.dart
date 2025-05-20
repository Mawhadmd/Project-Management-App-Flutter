

enum ProjectStatus {
  notStarted,
  inProgress,
  completed,
  onHold,
  cancelled,
}

class Project {
  final String id;
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String est;
  final ProjectStatus status;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.est,
    required this.endDate,
    this.status = ProjectStatus.notStarted,
  });
}