import 'package:finalmobileproject/models/project.class.dart';
import 'package:finalmobileproject/widgets/project/ProjectScreenTitleAndButton.dart';
import 'package:finalmobileproject/widgets/project/ProjectsSearch.dart';
import 'package:finalmobileproject/widgets/project/project_filters.dart';
import 'package:finalmobileproject/widgets/project/projects_holder.dart';
import 'package:flutter/material.dart';

class Projectsscreen extends StatefulWidget {
  const Projectsscreen({super.key});

  @override
  State<Projectsscreen> createState() => _ProjectsscreenState();
}

class _ProjectsscreenState extends State<Projectsscreen> {
  String searchphrase = '';
  ProjectStatus? selectedStatus;

  void setsearchvalue(String value) {
    setState(() {
      searchphrase = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Search(setsearchvalue: setsearchvalue),
          ProjectFilters(
            selectedStatus: selectedStatus,
            onStatusSelected: (status) {
              setState(() {
                selectedStatus = status;
              });
            },
          ),
          Newprojectbutton(
            searchphrase: searchphrase,
            selectedStatus: selectedStatus,
          ),
          const SizedBox(height: 20),
          Projectsholder(
            searchphrase: searchphrase,
            selectedStatus: selectedStatus,
          ),
        ],
      ),
    );
  }
}
