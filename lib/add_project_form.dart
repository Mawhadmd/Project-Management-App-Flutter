import 'package:date_field/date_field.dart';
import 'package:finalmobileproject/databaseInteractions/add_project.dart';
import 'package:finalmobileproject/class/project.class.dart';
import 'package:finalmobileproject/util/date_parser.dart';
import 'package:flutter/material.dart';

class Addprojectform extends StatefulWidget {
  const Addprojectform({super.key});

  @override
  State<Addprojectform> createState() => _AddprojectformState();
}

class _AddprojectformState extends State<Addprojectform> {
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  ProjectStatus? status = ProjectStatus.values.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
                controller: _projectNameController,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                controller: _descriptionController,
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                ),
                mode: DateTimeFieldPickerMode.date,
                firstDate: DateTime.now().add(Duration(days: 0)),
                initialPickerDateTime: DateTime.now().add(
                  const Duration(days: 20),
                ),
                onChanged: (DateTime? value) {
                  setState(() {
                    selectedStartDate = value;
                  });
                },
              ),
              SizedBox(height: 16),
              (selectedStartDate != null
                  ? DateTimeFormField(
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    firstDate:
                        selectedStartDate != null
                            ? selectedStartDate?.add(Duration(days: 1))
                            : DateTime.now(),

                    onChanged: (DateTime? value) {
                      setState(() {
                        selectedEndDate = value;
                      });
                    },
                  )
                  : Text("Please select a start date first")),
              const SizedBox(height: 16),
              DropdownButton<ProjectStatus>(
                value: status,
                items:
                    ProjectStatus.values
                        .where(
                          (e) =>
                              e != ProjectStatus.cancelled &&
                              e != ProjectStatus.completed,
                        )
                        .map(
                          (e) => DropdownMenuItem<ProjectStatus>(
                            value: e,
                            child: Text(e.toString().split('.').last),
                          ),
                        )
                        .toList(),
                onChanged: (ProjectStatus? newValue) {
                  setState(() {
                    status = newValue;
                  });
                },
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
               
                  if (_projectNameController.text.isEmpty ||
                      _descriptionController.text.isEmpty ||
                      selectedStartDate == null ||
                      selectedEndDate == null ||
                      status == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  } else {
                    String res = await addProject(
                      Project(
                        id: '',
                        name: _projectNameController.text,
                        description: _descriptionController.text,
                        startDate: dateParser(
                          selectedStartDate!,
                        ),
                        est: '0',
                        endDate: dateParser(
                          selectedStartDate!,
                        ),
                        status: status!,
                      ),
                    );
                      if (!context.mounted) return; 
                      if (res.contains("Error")) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $res')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Project added successfully'),
                          ),
                        );
                      }
                      Navigator.pop(context);
                 
                  }
                },
                child: const Text('Add Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
