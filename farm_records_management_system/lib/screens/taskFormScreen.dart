import 'package:flutter/material.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

class TaskFormScreen extends StatefulWidget {
  final int? taskId;

  TaskFormScreen({this.taskId});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _taskNameController;
  late TextEditingController _statusController;
  late TextEditingController _dateController;
  late TextEditingController _fieldController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _statusController = TextEditingController();
    _dateController = TextEditingController();
    _fieldController = TextEditingController();
    _notesController = TextEditingController();

    if (widget.taskId != null) {
      _loadTask();
    }
  }

  Future<void> _loadTask() async {
    if (widget.taskId == null) return;

    try {
      Map<String, dynamic>? task = await DatabaseHelper.getTaskById(widget.taskId!);
      if (task != null) {
        _taskNameController.text = task['taskName'] ?? '';
        _statusController.text = task['status'] ?? '';
        _dateController.text = task['date'] ?? '';
        _fieldController.text = task['field'] ?? '';
        _notesController.text = task['notes'] ?? '';
      }
    } catch (e) {
      debugPrint('Error loading task: $e');
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _statusController.dispose();
    _dateController.dispose();
    _fieldController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final task = {
      'taskName': _taskNameController.text,
      'status': _statusController.text,
      'date': _dateController.text,
      'field': _fieldController.text,
      'notes': _notesController.text,
    };

    if (widget.taskId == null) {
      await DatabaseHelper.insertTask(task);
    } else {
      await DatabaseHelper.updateTask(widget.taskId!, task);
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _taskNameController,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a status';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fieldController,
                decoration: InputDecoration(labelText: 'Field'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a field';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter notes';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
