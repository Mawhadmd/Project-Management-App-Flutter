import 'package:supabase_flutter/supabase_flutter.dart';

class Tasksservice {
  final _db = Supabase.instance.client;

  getTasks(p_id) {
    return _db.from('Tasks').select().eq("projectID", p_id);
  }

  Future<dynamic> addTask({
    required String title,
    required String description,
    required int projectId,
    DateTime? startDate,
    DateTime? dueDate,
  }) async {
    final data = {
      'title': title,
      'description': description,
      'projectID': projectId,
      'isDone': false,
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
    };

    return await _db.from('Tasks').insert(data);
  }

  setisDone(bool value, int id) async {
    var res = await _db.from("Tasks").update({'isDone': value}).eq("id", id);
    return res;
  }

  Future<Map<String, dynamic>> deleteTask(int taskId) async {
    try {
      await _db.from("Tasks").delete().eq('id', taskId);
      return {'status': 'Success'};
    } catch (e) {
      return {'status': 'Error', 'details': e.toString()};
    }
  }

  Future<int> getTotalTasksCount() async {
    try {
      final response =
          await _db
              .from('Tasks')
              .select('id')
              .eq('owner', _db.auth.currentUser?.id as String)
              .count();
      return response.count;
    } catch (e) {
      print('Error getting total tasks count: $e');
      return -1;
    }
  }

  Future<int> getCompletedTasksCount() async {
    try {
      final response =
          await _db
              .from('Tasks')
              .select('id')
              .eq('owner', _db.auth.currentUser?.id as String)
              .eq('isDone', true)
              .count();
      return response.count;
    } catch (e) {
      print('Error getting completed tasks count: $e');
      return -1;
    }
  }
}
