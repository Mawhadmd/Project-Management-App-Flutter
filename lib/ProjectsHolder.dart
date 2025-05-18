import 'package:finalmobileproject/Projectcard.dart';
import 'package:finalmobileproject/types/project.class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Projectsholder extends StatefulWidget {
  const Projectsholder({super.key});

  @override
  State<Projectsholder> createState() => _ProjectsholderState();
}

class _ProjectsholderState extends State<Projectsholder> {
  final _fetchProjects = Supabase.instance.client.from('Projects').select();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchProjects,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No projects found.', style: TextStyle(fontSize: 20, color: Colors.grey)));
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
              id: projectsData[index]['id'],
              name: projectsData[index]['name'],
              est: projectsData[index]['est'],
              startDate: projectsData[index]['start_date'],
              endDate: projectsData[index]['end_date'],
              status: projectsData[index]['status'], 
              description: projectsData[index]['description'],
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