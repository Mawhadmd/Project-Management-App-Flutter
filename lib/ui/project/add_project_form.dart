import 'package:date_field/date_field.dart';
import 'package:finalmobileproject/Database_Interactions/ProjectService.dart';
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
  void processform() async {
    if (_projectNameController.text.isEmpty ||
        selectedStartDate == null ||
        selectedEndDate == null ||
        status == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    } else {
      Map<String, dynamic> res = await ProjectService().addProject(
        Project(
          id: '',
          name: _projectNameController.text,
          description: _descriptionController.text,
          startDate: dateParser(selectedStartDate!),
          est: '0',
          endDate: dateParser(selectedEndDate!),
          status: status!,
        ),
      );

      if (!context.mounted) return;
      final projectId = res['id'];
      if (projectId?.contains("Error") ?? false || res['status'] == "Error") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${res["details"]}')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project added successfully')),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Project',
          // , style: TextStyle(color: Colors.white)
        ),
        // backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(100),
        // iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            padding: EdgeInsets.only(top: 4),
            children: [
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(100),
                    ),
                  ),
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
                controller: _projectNameController,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(100),
                    ),
                  ),
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                controller: _descriptionController,
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(100),
                    ),
                  ),
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
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(100).withAlpha(100),
                        ),
                      ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onPressed: processform,
                child: Text('Add Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
