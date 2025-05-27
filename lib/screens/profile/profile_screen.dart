import 'package:finalmobileproject/Auth/AuthProvider.dart';
import 'package:finalmobileproject/Auth/LoginScreen.dart';
import 'package:finalmobileproject/screens/profile/about_screen.dart';
import 'package:finalmobileproject/screens/profile/edit_profile_screen.dart';
import 'package:finalmobileproject/screens/profile/help_screen.dart';
import 'package:finalmobileproject/screens/profile/notification_screen.dart';
import 'package:finalmobileproject/screens/profile/privacy_screen.dart';
import 'package:finalmobileproject/utils/decimal_to_alpha_colors.dart';
import 'package:flutter/material.dart';
import '../../services/ProjectService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  bool _isGoogleUser() {
    final user = Supabase.instance.client.auth.currentUser;
    return user?.appMetadata['provider'] == 'google';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isGoogleUser = _isGoogleUser();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Profile Image
                    ProjectService().getUserImage() == null
                        ? Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black.withAlpha(100),
                            ),
                            shape: BoxShape.circle,
                            color: colorScheme.primary.withAlpha(
                              decimal_to_alpha_colors(0.1),
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: colorScheme.primary,
                          ),
                        )
                        : Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black.withAlpha(100),
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            ProjectService().getUserImage()!,
                            fit: BoxFit.cover,
                          ),
                        ),
                    const SizedBox(height: 16),
                    // Username
                    FutureBuilder<String?>(
                      future: ProjectService().getUserName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        final username = snapshot.data ?? "User";
                        return Text(
                          username,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Member since 2024',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Profile Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!isGoogleUser) // Only show edit profile for non-Google users
                      _buildSettingItem(
                        context,
                        'Edit Profile',
                        Icons.edit_outlined,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                    _buildSettingItem(
                      context,
                      'Notifications',
                      Icons.notifications_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingItem(
                      context,
                      'Privacy',
                      Icons.lock_outline,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyScreen(),
                          ),
                        );
                      },
                    ),
                    _buildSettingItem(
                      context,
                      'Help & Support',
                      Icons.help_outline,
                      () {
                        if (!isGoogleUser) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportScreen(),
                            ),
                          );
                        }
                      },
                      isDisabled: isGoogleUser,
                    ),
                    _buildSettingItem(context, 'About', Icons.info_outline, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Authprovider().signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDisabled = false,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isDisabled
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDisabled ? Colors.grey : null,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: isDisabled ? Colors.grey[400] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
