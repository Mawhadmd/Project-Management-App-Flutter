import 'package:finalmobileproject/class/project.class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ProjectService {
  final _db = Supabase.instance.client;

  // Get current user's name
  Future<String?> getUserName() async {
    try {
      final user = _db.auth.currentUser;
      if (user == null) return null;
      
      final response = await _db
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();
      
      return response['full_name'];
    } catch (e) {
      return null;
    }
  }

  // Add new project
  Future<Map<String, dynamic>> addProject(Project project) async {
    if (project.name.isEmpty) {
      return {'status': 'Error', 'details': 'Project name cannot be empty'};
    }
    if (project.est.isEmpty) {
      return {'status': 'Error', 'details': 'Project estimate cannot be empty'};
    }
    if (project.startDate.isEmpty) {
      return {'status': 'Error', 'details': 'Project start date cannot be empty'};
    }
    if (project.endDate.isEmpty) {
      return {'status': 'Error', 'details': 'Project end date cannot be empty'};
    }

    try {
      final id = await _db.from("Projects").insert({
        'name': project.name,
        'description': project.description,
        'est': project.est,
        'startDate': DateFormat('d MMM yyyy').parse(project.startDate).toIso8601String(),
        'endDate': DateFormat('d MMM yyyy').parse(project.endDate).toIso8601String(),
        'status': project.status.name,
      }).select('id').single();
      
      return {'status': 'Success', 'id': id['id']};
    } on PostgrestException catch (e) {
      return {'status': 'Error', 'details': '${e.message} ${e.code}'};
    }
  }

  // Edit existing project
  Future<Map<String, dynamic>> editProject(String projectId, Project project) async {
    try {
      await _db.from("Projects").update({
        'name': project.name,
        'description': project.description,
        'est': project.est,
        'startDate': DateFormat('d MMM yyyy').parse(project.startDate).toIso8601String(),
        'endDate': DateFormat('d MMM yyyy').parse(project.endDate).toIso8601String(),
        'status': project.status.name,
      }).eq('id', projectId);
      
      return {'status': 'Success'};
    } on PostgrestException catch (e) {
      return {'status': 'Error', 'details': '${e.message} ${e.code}'};
    }
  }

  // Delete project
  Future<Map<String, dynamic>> deleteProject(String projectId) async {
    try {
      await _db.from("Projects").delete().eq('id', projectId);
      return {'status': 'Success'};
    } on PostgrestException catch (e) {
      return {'status': 'Error', 'details': '${e.message} ${e.code}'};
    }
  }

  // Update profile picture
  Future<Map<String, dynamic>> updateProfilePicture(String imageUrl) async {
    try {
      final user = _db.auth.currentUser;
      if (user == null) {
        return {'status': 'Error', 'details': 'No user logged in'};
      }

      await _db.from('profiles').update({
        'avatar_url': imageUrl,
      }).eq('id', user.id);
      
      return {'status': 'Success'};
    } on PostgrestException catch (e) {
      return {'status': 'Error', 'details': '${e.message} ${e.code}'};
    }
  }
}
