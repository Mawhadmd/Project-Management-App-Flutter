import 'package:finalmobileproject/Database_Interactions/ProjectService.dart';
import 'package:finalmobileproject/ui/project/project_card.dart';
import 'package:finalmobileproject/types/project.class.dart';
import 'package:finalmobileproject/util/date_parser.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class Projectsholder extends StatefulWidget {
  const Projectsholder({super.key});

  @override
  State<Projectsholder> createState() => ProjectsholderState();
}

class ProjectsholderState extends State<Projectsholder> {
  final _projectService = ProjectService();
  late final Stream<List<Map<String, dynamic>>> _projectsStream;

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
  }

  @override
  Widget build(BuildContext context) {
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
          return ListView.builder(
            shrinkWrap: true,
            itemCount: projectsData.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Projectcard(
                  project: Project(
                    id: projectsData[index]['id'].toString(),
                    name: projectsData[index]['name'].toString(),
                    est: projectsData[index]['est'].toString(),
                    startDate: dateParser(
                      projectsData[index]['startDate'].toString(),
                    ),
                    endDate: dateParser(
                      projectsData[index]['endDate'].toString(),
                    ),
                    status: ProjectStatus.values.firstWhere(
                      (e) => e.name == projectsData[index]['status'],
                    ),
                    description: projectsData[index]['description'].toString(),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
