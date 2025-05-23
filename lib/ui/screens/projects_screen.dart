
import 'package:finalmobileproject/ui/project/ProjectScreenTitleAndButton.dart';
import 'package:finalmobileproject/ui/project/projects_holder.dart';
import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [ Newprojectbutton(),Projectsholder()],) ;
  }
}
