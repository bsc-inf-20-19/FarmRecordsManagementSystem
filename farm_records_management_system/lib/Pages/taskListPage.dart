import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:farm_records_management_system/database/databaseHelper.dart';
import 'package:farm_records_management_system/screens/taskFormScreen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, dynamic>> tasks = [];
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadTasks();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      List<Map<String, dynamic>> result = await DatabaseHelper.getTasks();
      setState(() {
        tasks = result.reversed.toList();
      });
    } catch (e) {
      debugPrint('Error loading tasks: $e');
    }
  }

  void _applySearchFilter(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        isSearching = false;
        _loadTasks();
      } else {
        isSearching = true;
        tasks = tasks.where((task) {
          return task.values.any((value) =>
              value.toString().toLowerCase().contains(searchTerm.toLowerCase()));
        }).toList();
      }
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'Invalid Date';
    }
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat("yyyy-MM-dd").format(date);
    } catch (e) {
      debugPrint('Invalid date format: $e');
      return 'Invalid Date';
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int taskId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await DatabaseHelper.deleteTask(taskId);
                _loadTasks();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddTaskPage() async {
    final addedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(),
      ),
    );
    if (addedTask != null) {
      _loadTasks();
    }
  }

  void _navigateToEditTaskPage(int taskId) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(taskId: taskId),
      ),
    );
    if (updatedTask != null) {
      _loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                onChanged: (value) => _applySearchFilter(value),
                decoration: const InputDecoration(
                  hintText: 'Search by task name, status, or date',
                  border: InputBorder.none,
                ),
              )
            : const Text('Task List'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                }
                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final taskName = task['taskName'] ?? 'N/A';
          final status = task['status'] ?? 'N/A';
          final date = task['date'] ?? 'N/A';
          final field = task['field'] ?? 'N/A';
          final notes = task['notes'] ?? 'N/A';

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        taskName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              _navigateToEditTaskPage(task['id']);
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(context, task['id']);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.5, color: Colors.black54),
                  const SizedBox(height: 8),
                  TaskItem(label: 'Status', value: status, color: Colors.green),
                  TaskItem(label: 'Date', value: _formatDate(date), color: Colors.blue),
                  TaskItem(label: 'Field', value: field, color: Colors.orange),
                  TaskItem(label: 'Notes', value: notes, color: Colors.purple),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTaskPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const TaskItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
