import 'package:finalmobileproject/class/project.class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> addProject(Project project) async {
  final db = Supabase.instance.client;
  final String id;

  if (project.name.isEmpty)
    return {'status': 'Error', 'details': 'Project name cannot be empty'};
  // if (project.description.isEmpty) {
  //   return {'status': 'Error', 'details': 'Project description cannot be empty'};
  // }
  if (project.est.isEmpty)
    return {'status': 'Error', 'details': 'Project estimate cannot be empty'};
  if (project.startDate.isEmpty) {
    return {'status': 'Error', 'details': 'Project start date cannot be empty'};
  }
  if (project.endDate.isEmpty) {
    return {'status': 'Error', 'details': 'Project end date cannot be empty'};
  }
  try {
    id = await db.from("Projects").insert({
      'name': project.name,
      'description': project.description,
      'est': project.est,
      'startDate':
          DateFormat('d MMM yyyy').parse(project.startDate).toIso8601String(),
      'endDate':
          DateFormat('d MMM yyyy').parse(project.endDate).toIso8601String(),
      'status': project.status.name,
    });
  } on PostgrestException catch (e) {
    return {'status': 'Error', "details": e.message + " " + e.code.toString()};
  }

  return {'status': 'Success', "id": id};
}
