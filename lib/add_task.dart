import 'package:flutter/material.dart';


class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String newTask = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lägg till',
          style: TextStyle(fontSize: 32), 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                setState(() {
                  newTask = text;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  Navigator.pop(context, newTask);
              }
            }, 
            backgroundColor: Colors.white,
            child: const Icon(Icons.add, 
              size: 40, 
              color: Colors.grey),
            ),
          ],
        ),
      )
    );
  }
}

