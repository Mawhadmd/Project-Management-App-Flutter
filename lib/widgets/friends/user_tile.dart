import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback? onAddFriend;
  final String buttonLabel;

  const UserTile({
    super.key,
    required this.user,
    required this.onAddFriend,
    this.buttonLabel = 'Add Friend',
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.userMetadata?['avatar_url'];
    final name = user.userMetadata?['name'] ?? 'No Name';

    return ListTile(
      leading:
          avatarUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
              : const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      trailing: ElevatedButton.icon(
        icon: const Icon(Icons.person_add),
        label: Text(buttonLabel),
        onPressed: onAddFriend,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}