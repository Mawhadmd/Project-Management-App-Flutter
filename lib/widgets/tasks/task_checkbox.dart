import 'package:finalmobileproject/services/TasksService.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TaskCheckbox extends StatefulWidget {
  const TaskCheckbox({super.key, required this.isDone, required this.id});
  final bool isDone;
  final int id;
  @override
  State<TaskCheckbox> createState() => _TaskCheckboxState();
}

class _TaskCheckboxState extends State<TaskCheckbox> {
  late bool checkboxValue;
  Timer? _debounce;
  bool _isUpdating = false;

  @override
  void initState() {
    checkboxValue = widget.isDone;
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: checkboxValue,
      onChanged:
          _isUpdating
              ? null
              : (value) {
                if (_debounce?.isActive ?? false) return;

                _debounce = Timer(const Duration(milliseconds: 150), () async {
                  try {
                    setState(() => _isUpdating = true);
                    await Tasksservice().setisDone(!checkboxValue, widget.id);
                    setState(() {
                      checkboxValue = !checkboxValue;
                      _isUpdating = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfull'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    setState(() => _isUpdating = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating task status: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                });
              },
    );
  }
}
