import 'package:finalmobileproject/ui/project/project_card.dart';
import 'package:finalmobileproject/types/project.class.dart';
import 'package:finalmobileproject/util/date_parser.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class Projectsholder extends StatefulWidget {
  const Projectsholder({
    super.key,
    required this.searchphrase,
    this.selectedStatus,
  });
  final String searchphrase;
  final ProjectStatus? selectedStatus;

  @override
  State<Projectsholder> createState() => ProjectsholderState();
}

class ProjectsholderState extends State<Projectsholder> {
  late final Stream<List<Map<String, dynamic>>> _projectsStream;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      _projectsStream = Stream.value([]);
      return;
    }
    _projectsStream = Supabase.instance.client
        .from('Projects')
        .stream(primaryKey: ['id'])
        .eq('owner', userId);

    // Add loading delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
      stream: _projectsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No projects found.',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          );
        } else {
          final projectsData = snapshot.data!;
          final filteredProjects =
              projectsData.where((project) {
                // Search filter
                if (widget.searchphrase.isNotEmpty) {
                  final projectName = project['name'].toString().toLowerCase();
                  final searchValue = widget.searchphrase.toLowerCase();
                  if (!projectName.contains(searchValue)) return false;
                }

                // Status filter
                if (widget.selectedStatus != null) {
                  final projectStatus = ProjectStatus.values.firstWhere(
                    (e) => e.name == project['status'],
                  );
                  if (projectStatus != widget.selectedStatus) return false;
                }

                return true;
              }).toList();

          if (filteredProjects.isEmpty) {
            return const Center(
              child: Text(
                'No matching projects found.',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          return Expanded(
            child: ListView.builder(
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Projectcard(
                    project: Project(
                      id: filteredProjects[index]['id'].toString(),
                      name: filteredProjects[index]['name'].toString(),
                      est: filteredProjects[index]['est'].toString(),
                      startDate: dateParser(
                        filteredProjects[index]['startDate'].toString(),
                      ),
                      endDate: dateParser(
                        filteredProjects[index]['endDate'].toString(),
                      ),
                      status: ProjectStatus.values.firstWhere(
                        (e) => e.name == filteredProjects[index]['status'],
                      ),
                      description:
                          filteredProjects[index]['description'].toString(),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
