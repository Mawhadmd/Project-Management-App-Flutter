import 'package:finalmobileproject/class/project.class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> addProject(Project project) async {
  final db = Supabase.instance.client;
  final String id;
  try {
    id = await db.from("Projects").insert({
      'name': project.name,
      'description': project.description,
      'est': project.est,
      'startDate': DateTime.parse(project.startDate).toIso8601String(),
      'endDate':DateTime.parse(project.endDate).toIso8601String(),
      'status': project.status.name,
    });
  } catch (e) {
    return "Error: $e";
  }

  return id;
}
