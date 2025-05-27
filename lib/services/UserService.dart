import 'package:supabase_flutter/supabase_flutter.dart';

class Userservice {
  final supabase = Supabase.instance.client;

  Future<List<User>> getusers() async {
    var users = await supabase.auth.admin.listUsers();

    return users;
  }

  Future<void> sendFriendRequest(String userId, String friendId) async {
    await supabase.from('friends').insert({
      'user_id': userId,
      'friend_id': friendId,
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> getIncomingFriendRequests(
    String userId,
  ) async {
    final response = await supabase
        .from('friends')
        .select('id, user_id, status')
        .eq('friend_id', userId)
        .eq('status', 'pending');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> respondToFriendRequest(String requestId, String status) async {
    await supabase
        .from('friends')
        .update({'status': status})
        .eq('id', requestId);
  }

  Future<String?> getFriendshipStatus(String userId, String friendId) async {
    final response =
        await supabase
            .from('friends')
            .select('status')
            .or('user_id.eq.$userId,friend_id.eq.$userId')
            .or('user_id.eq.$friendId,friend_id.eq.$friendId')
            .maybeSingle();
    return response?['status'];
  }
}
