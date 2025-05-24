import 'package:supabase_flutter/supabase_flutter.dart';

class Tasksservice {
  final _db = Supabase.instance.client;

  get_tasks_for_a_project(p_id) {
    return _db.from('Tasks').select().eq("projectID", p_id);
  }
}
