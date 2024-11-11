import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'task.dart';
import 'add_task.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = DatabaseHelper().getTasks(); // Load tasks from the database
  }

  void _refreshTasks() {
    setState(() {
      tasks = DatabaseHelper().getTasks(); // Refresh the task list
    });
  }

  void _addTask(Task task) async {
    await DatabaseHelper().insertTask(task);
    _refreshTasks(); // Refresh tasks after adding a new task
  }

  void _updateTask(Task task) async {
    task.isCompleted = !task.isCompleted; // Toggle completion status
    await DatabaseHelper().updateTask(task);
    _refreshTasks(); // Refresh tasks after updating
  }

  void _deleteTask(int? id) async {
    if (id != null) {
      await DatabaseHelper().deleteTask(id);
      _refreshTasks(); // Refresh tasks after deleting
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTaskDialog(
          onSave: (task) {
            _addTask(task);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Dashboard'),
      ),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final taskList = snapshot.data!;

          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              final task = taskList[index];
              return ListTile(
                title: Text(task.name),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    _updateTask(task);
                  },
                ),
                onLongPress: () => _deleteTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog, // Show dialog to add a new task
        child: Icon(Icons.add),
      ),
    );
  }
}
