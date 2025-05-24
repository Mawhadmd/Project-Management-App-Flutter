import 'package:finalmobileproject/models/project.class.dart';
import 'package:flutter/material.dart';

class Newprojectbutton extends StatelessWidget {
  const Newprojectbutton({
    super.key,
    required this.searchphrase,
    this.selectedStatus,
  });

  final String searchphrase;
  final ProjectStatus? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/newproject', arguments: selectedStatus);
      },
      child: const Icon(Icons.add),
    );
  }
}
