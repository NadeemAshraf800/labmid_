import 'package:flutter/material.dart';
import 'task.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onSave;

  AddTaskDialog({required this.onSave});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isRepeated = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          ListTile(
            title: Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
          ),
          CheckboxListTile(
            title: Text('Repeat Task'),
            value: isRepeated,
            onChanged: (value) {
              setState(() {
                isRepeated = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final task = Task(
              name: nameController.text,
              description: descriptionController.text,
              date: selectedDate,
              isRepeated: isRepeated,
            );
            widget.onSave(task);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
