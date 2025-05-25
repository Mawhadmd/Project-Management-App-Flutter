import 'package:flutter/material.dart';
import 'package:finalmobileproject/services/TasksService.dart';

class AddNewTaskScreen extends StatefulWidget {
  final int projectId;
  const AddNewTaskScreen({super.key, required this.projectId});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _dueDate;
  bool _startTomorrow = false;
  final Tasksservice _tasksService = Tasksservice();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // If due date is before new start date, reset it
        if (_dueDate != null && _dueDate!.isBefore(_startDate!)) {
          _dueDate = null;
        }
      });
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // If start tomorrow is checked, set start date to tomorrow
      if (_startTomorrow) {
        _startDate = DateTime.now().add(const Duration(days: 1));
      }

      await _tasksService.addTask(
        title: _titleController.text,
        description: _descriptionController.text,
        projectId: widget.projectId,
        startDate: _startDate,
        dueDate: _dueDate,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Start Tomorrow'),
                value: _startTomorrow,
                onChanged: (bool? value) {
                  setState(() {
                    _startTomorrow = value ?? false;
                    if (_startTomorrow) {
                      _startDate =
                          null; // Clear start date if start tomorrow is checked
                    }
                  });
                },
              ),
              if (!_startTomorrow) ...[
                ListTile(
                  title: const Text('Start Date'),
                  subtitle: Text(
                    _startDate == null
                        ? 'No start date set'
                        : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectStartDate(context),
                  ),
                ),
              ],
              ListTile(
                title: const Text('Due Date'),
                subtitle: Text(
                  _dueDate == null
                      ? 'No due date set'
                      : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed:
                      _startDate == null && !_startTomorrow
                          ? null
                          : () => _selectDueDate(context),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
