import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';

class TaskFormScreen extends StatefulWidget {
  final int? taskId;

  TaskFormScreen({this.taskId});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isSpecificToPlanting = false;
  String? _selectedField;
  String? _notes;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _loadTask(widget.taskId!);
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _loadTask(int taskId) async {
    try {
      var task = await DatabaseHelper.getTaskById(taskId);
      if (task != null) {
        setState(() {
          _taskNameController.text = task['taskName'] ?? '';
          _dateController.text = task['date'] ?? '';
          _isSpecificToPlanting = task['isSpecificToPlanting'] ?? false;
          _selectedField = task['field'];
          _notes = task['notes'];
        });
      }
    } catch (e) {
      debugPrint('Error loading task: $e');
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String status = DateFormat("yyyy-MM-dd")
              .parse(_dateController.text)
              .isBefore(DateTime.now())
          ? 'Done'
          : 'Planned';

      Map<String, dynamic> newTask = {
        'taskName': _taskNameController.text,
        'status': status,
        'isSpecificToPlanting': _isSpecificToPlanting,
        'field': _selectedField,
        'notes': _notes,
        'date': _dateController.text,
      };

      if (widget.taskId == null) {
        await DatabaseHelper.insertTask(newTask);
      } else {
        await DatabaseHelper.updateTask(widget.taskId!, newTask);
      }
      Navigator.pop(context, true);
    }
  }

  Future<List<Map<String, dynamic>>> _getFields() async {
    return await DatabaseHelper.getFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.taskId == null ? 'New Task' : 'Edit Task')),
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
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true, // Set text field as read-only
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Specific to a Planting?'),
                value: _isSpecificToPlanting,
                onChanged: (value) {
                  setState(() {
                    _isSpecificToPlanting = value;
                  });
                },
              ),
              if (_isSpecificToPlanting) FutureBuilder<List<Map<String, dynamic>>>(
                future: _getFields(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<DropdownMenuItem<String>> items = snapshot.data!
                        .map((field) => DropdownMenuItem<String>(
                              value: field['fieldName'],
                              child: Text(field['fieldName']),
                            ))
                        .toList();
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Field'),
                      value: _selectedField,
                      items: items,
                      onChanged: (value) {
                        setState(() {
                          _selectedField = value;
                        });
                      },
                      validator: (value) {
                        if (_isSpecificToPlanting && value == null) {
                          return 'Please select a field';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                maxLines: 3,
                onSaved: (value) {
                  _notes = value;
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
