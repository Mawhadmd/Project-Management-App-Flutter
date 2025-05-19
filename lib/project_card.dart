import 'package:finalmobileproject/class/project.class.dart';
import 'package:flutter/material.dart';

class Projectcard extends StatelessWidget {
  const Projectcard({
    super.key,
    required this.project
  });
  final Project project;
  
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style:  TextStyle(
        color: Theme.of(context).colorScheme.surface,
        
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary, 
          
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(color: Colors.black12),
              ),
              child: Text(
                project.status == "completed" ? "Completed" : project.status == "in progress" ? "In Progress" : "Not Started",
                style: TextStyle(
                  color: project.status == "completed" ? Colors.green : project.status == "in progress" ? Colors.orange : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              
              ),
            ),
            const SizedBox(height: 8),
            Text(
              project.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children:  [
                Icon(Icons.calendar_today, size: 16, color: Theme.of(context).colorScheme.surface,),
                SizedBox(width: 6),
                Text("Due ${project.endDate}"),
                SizedBox(width: 20),
                Icon(Icons.access_time, size: 16 , color: Theme.of(context).colorScheme.surface),
                SizedBox(width: 6),
                Text("Est ${project.est}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
