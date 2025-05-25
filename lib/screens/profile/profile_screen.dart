import 'package:finalmobileproject/screens/projects/projects_screen.dart';
import 'package:finalmobileproject/utils/decimal_to_alpha_colors.dart';
import 'package:finalmobileproject/widgets/profile/ActionButton.dart';
import 'package:finalmobileproject/widgets/profile/StatCard.dart';
import 'package:flutter/material.dart';
import 'package:finalmobileproject/screens/profile/UserSettings.dart';
import 'package:finalmobileproject/screens/teams/teams_screen.dart';

import '../../services/ProjectService.dart';
import '../../services/TasksService.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    ProjectService().getUserImage() == null
                        ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary.withAlpha(
                              decimal_to_alpha_colors(0.1),
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: colorScheme.primary,
                          ),
                        )
                        : Container(
                          width: double.infinity,
                          height: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Image.network(
                            ProjectService().getUserImage()!,
                            fit: BoxFit.contain,
                          ),
                        ),
                    const SizedBox(height: 16),
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
                            color: colorScheme.onPrimaryContainer,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        StatCard(
                          context,
                          'Total Projects',
                          FutureBuilder(
                            future: ProjectService().getProjectsCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError || snapshot.data == null) {
                                return Text(
                                  '0',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                );
                              }
                              return Text(
                                snapshot.data.toString(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              );
                            },
                          ),
                          Icons.folder_outlined,
                          colorScheme.primary,
                        ),
                        StatCard(
                          context,
                          'Total Tasks',
                          FutureBuilder<int>(
                            future: Tasksservice().getTotalTasksCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError || snapshot.data == null) {
                                return Text(
                                  '0',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                );
                              }
                              return Text(
                                snapshot.data.toString(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              );
                            },
                          ),
                          Icons.folder_outlined,
                          colorScheme.primary,
                        ),
                        StatCard(
                          context,
                          'Completed Tasks',
                          FutureBuilder<int>(
                            future: Tasksservice().getCompletedTasksCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError || snapshot.data == null) {
                                return Text(
                                  '0',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.tertiary,
                                  ),
                                );
                              }
                              return Text(
                                snapshot.data.toString(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.tertiary,
                                ),
                              );
                            },
                          ),
                          Icons.check_circle_outline,
                          colorScheme.tertiary,
                        ),
                        StatCard(
                          context,
                          'Team Members',
                          Text(
                            '5',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.error,
                            ),
                          ),
                          Icons.people_outline,
                          colorScheme.error,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ActionButton(
                      context,
                      'Settings',
                      Icons.settings_outlined,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Usersettings(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ActionButton(
                      context,
                      'View Projects',
                      Icons.folder_outlined,
                      () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Projectsscreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ActionButton(context, 'Teams', Icons.people_outline, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeamsScreen(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
