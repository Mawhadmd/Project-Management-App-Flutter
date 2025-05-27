import 'package:finalmobileproject/services/UserService.dart';
import 'package:finalmobileproject/widgets/friends/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  String searchQuery = '';
  late Future<List<User>> usersFuture;
  final currentUser = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    usersFuture = Userservice().getusers();
  }

  void sendFriendRequest(String friendId) async {
    final userId = currentUser?.id;
    if (userId == null) return;
    try {
      await Userservice().sendFriendRequest(userId, friendId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Friend request sent!')));
      setState(() {}); // Refresh UI
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void showFriendRequests() async {
    final userId = currentUser?.id;
    if (userId == null) return;
    final requests = await Userservice().getIncomingFriendRequests(userId);
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SizedBox(
            height: 300,
            child:
                requests.isEmpty
                    ? const Center(child: Text('No friend requests yet.'))
                    : ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        return FutureBuilder(
                          future: Userservice().getuserbyid(req['user_id']),
                          builder: (context, snapshot) {
                            final username = snapshot.data ?? 'Unknown';
                            return ListTile(
                              title: Text('Request from: $username'),
                              subtitle: Text('Status: ${req['status']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    onPressed: () async {
                                      await Userservice()
                                          .respondToFriendRequest(
                                            req['id'],
                                            'accepted',
                                          );
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await Userservice()
                                          .respondToFriendRequest(
                                            req['id'],
                                            'rejected',
                                          );
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
    );
  }

  void showAllFriends() async {
    final userId = currentUser?.id;
    if (userId == null) return;
    final friends = await Userservice().getAllFriends(userId);
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SizedBox(
            height: 400,
            child:
                friends.isEmpty
                    ? const Center(child: Text('No friends yet.'))
                    : ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return FutureBuilder(
                          future: Userservice().getuserbyid(
                            friend['friend_id'] == userId
                                ? friend['user_id']
                                : friend['friend_id'],
                          ),
                          builder: (context, snapshot) {
                            final username = snapshot.data ?? 'Unknown';
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(username.toString()),
                              subtitle: Text(
                                'Friend since: ${friend['created_at']?.toString().substring(0, 10) ?? ''}',
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          actions: [
            IconButton(
              icon: const Icon(Icons.people),
              tooltip: 'All Friends',
              onPressed: showAllFriends,
            ),
            IconButton(
              icon: const Icon(Icons.mail),
              tooltip: 'Friend Requests',
              onPressed: showFriendRequests,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search people...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 16),
              // User list
              Expanded(
                child: FutureBuilder<List<User>>(
                  future: usersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No users found.'));
                    }

                    // Filter users: only Google users, not current user, and search
                    final filteredUsers =
                        snapshot.data!.where((user) {
                          final name =
                              user.userMetadata?['name']?.toLowerCase() ?? '';
                          final email = user.email?.toLowerCase() ?? '';
                          return user.id != currentUser?.id &&
                              user.appMetadata?['provider'] == 'google' &&
                              (name.contains(searchQuery) ||
                                  email.contains(searchQuery));
                        }).toList();

                    if (filteredUsers.isEmpty) {
                      return const Center(
                        child: Text('No users match your search.'),
                      );
                    }

                    return ListView.separated(
                      itemCount: filteredUsers.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return FutureBuilder<String?>(
                          future: Userservice().getFriendshipStatus(
                            currentUser!.id,
                            user.id,
                          ),
                          builder: (context, snapshot) {
                            final status = snapshot.data;
                            final isPending = status == 'pending';
                            final isFriend = status == 'accepted';
                            return UserTile(
                              user: user,
                              onAddFriend:
                                  isPending || isFriend
                                      ? null
                                      : () => sendFriendRequest(user.id),
                              buttonLabel:
                                  isFriend
                                      ? 'Friends'
                                      : isPending
                                      ? 'Pending'
                                      : 'Add Friend',
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
