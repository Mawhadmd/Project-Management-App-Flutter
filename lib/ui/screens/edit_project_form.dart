import 'package:date_field/date_field.dart';
import 'package:finalmobileproject/Database_Interactions/ProjectService.dart';
import 'package:finalmobileproject/types/project.class.dart';
import 'package:finalmobileproject/util/date_parser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProjectForm extends StatefulWidget {
  final Project project;

  const EditProjectForm({super.key, required this.project});

  @override
  State<EditProjectForm> createState() => _EditProjectFormState();
}

class _EditProjectFormState extends State<EditProjectForm> {
  late final TextEditingController _projectNameController;
  late final TextEditingController _descriptionController;
  late DateTime? selectedStartDate;
  late DateTime? selectedEndDate;
  late ProjectStatus? status;

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(
      text: widget.project.description,
    );
    selectedStartDate = DateFormat(
      'd MMM yyyy',
    ).parse(widget.project.startDate);
    selectedEndDate = DateFormat('d MMM yyyy').parse(widget.project.endDate);
    status = widget.project.status;
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void processForm() async {
    if (_projectNameController.text.isEmpty ||
        selectedStartDate == null ||
        selectedEndDate == null ||
        status == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    Map<String, dynamic> res = await ProjectService().editProject(
      widget.project.id,
      Project(
        id: widget.project.id,
        name: _projectNameController.text,
        description: _descriptionController.text,
        startDate: dateParser(selectedStartDate!),
        est: widget.project.est,
        endDate: dateParser(selectedEndDate!),
        status: status!,
      ),
    );

    if (context.mounted) {
      if (res['status'] == "Error") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${res["details"]}')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project updated successfully')),
        );
        Navigator.pop(context, true); // Pop back with success flag
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            padding: const EdgeInsets.only(top: 4),
            children: [
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(100),
                    ),
                  ),
                  labelText: 'Project Name',
                  border: const OutlineInputBorder(),
                ),
                controller: _projectNameController,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(100),
                    ),
                  ),
                  labelText: 'Description',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                controller: _descriptionController,
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(100),
                    ),
                  ),
                  labelText: 'Start Date',
                  border: const OutlineInputBorder(),
                ),
                initialValue: selectedStartDate,
                onChanged: (DateTime? value) {
                  setState(() {
                    selectedStartDate = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(100),
                    ),
                  ),
                  labelText: 'End Date',
                  border: const OutlineInputBorder(),
                ),
                initialValue: selectedEndDate,
                onChanged: (DateTime? value) {
                  setState(() {
                    selectedEndDate = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ProjectStatus>(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(100),
                    ),
                  ),
                  labelText: 'Status',
                  border: const OutlineInputBorder(),
                ),
                value: status,
                items:
                    ProjectStatus.values.map((ProjectStatus value) {
                      return DropdownMenuItem<ProjectStatus>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
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
                onPressed: processForm,
                child: const Text('Update Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
