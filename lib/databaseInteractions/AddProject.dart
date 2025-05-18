import 'package:finalmobileproject/types/project.class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> addProject(
Project project,
) async {
  final db = await Supabase.instance.client.from('projects');
  final id = await db.insert('projects', {
    'endDate': project.endDate,
    'name': project.name,
    'description': project.description,
    'EST': project.est,
    'startDate': project.startDate,
    'Status': project.status,
  });
  return id;
}
