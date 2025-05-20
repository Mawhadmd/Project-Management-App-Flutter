import 'package:finalmobileproject/class/project.class.dart';
import 'package:flutter/material.dart';

class Projectcard extends StatelessWidget {
  const Projectcard({super.key, required this.project});
  final Project project;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,

        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 238, 238),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(14, 14, 14, 100),
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.black12),
              ),
              child: Text(
                project.status.name == "completed"
                    ? "Completed"
                    : project.status.name == "inProgress"
                    ? "In Progress"
                    : project.status.name == "onHold"
                    ? "On Hold"
                    : project.status.name == "cancelled"
                    ? "Cancelled"
                    : "Not Started",
                style: TextStyle(
                  color:
                      project.status.name == "completed"
                          ? Colors.green
                          : project.status.name == "inProgress"
                          ? Colors.orange
                          : project.status.name == "onHold"
                          ? Colors.blue
                          : project.status.name == "cancelled"
                          ? Colors.red
                          : Color.fromRGBO(9, 9, 9, 100),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              project.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: 6),
                Text("Due ${project.endDate}"),
                SizedBox(width: 20),
                Icon(
                  Icons.access_time,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(width: 6),
                Text("Est ${project.est}h"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
