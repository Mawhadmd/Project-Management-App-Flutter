import 'package:finalmobileproject/types/project.class.dart';
import 'package:finalmobileproject/ui/project/ProjectScreenTitleAndButton.dart';
import 'package:finalmobileproject/ui/project/ProjectsSearch.dart';
import 'package:finalmobileproject/ui/project/project_filters.dart';
import 'package:finalmobileproject/ui/project/projects_holder.dart';
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
    return Column(
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
    );
  }
}
