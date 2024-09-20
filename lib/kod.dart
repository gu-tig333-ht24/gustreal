import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class Items {
  final String titel;
  bool done; 

  Items(this.titel, this.done);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Items> aktiviteter = [
    Items('Diska', false), 
    Items('Laga mat', false), 
    Items('Städa', false), 
  ];

String filter = 'Alla';

List<Items> get filteredItems {
  if (filter == 'Färdig') {
    return aktiviteter.where((item) => item.done).toList();
  } else if (filter == 'Ej färdig') {
    return aktiviteter.where((item) => !item.done).toList();
  }
  return aktiviteter;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text(
          'Påminnelser',
          style: TextStyle(fontSize: 32), 
        ),
      actions: [
        PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                filter = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Alla',
                child: Text('Alla'),
              ),
              const PopupMenuItem<String>(
                value: 'Färdig',
                child: Text('Färdig'),
              ),
              const PopupMenuItem<String>(
                value: 'Ej färdig',
                child: Text('Ej färdig'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [         
           for (var aktiviteter in filteredItems) _item(aktiviteter),
        ], 
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          );
          if (result != null && result is String) {
            setState(() {
              aktiviteter.add(Items(result, false));
            }
          );
        }
      },
      backgroundColor: Colors.white,
        child: const Icon(Icons.add, 
          size: 40, 
          color: Colors.grey),
      ),
    );
  }

  Widget _item(Items aktivitet) {
    return GestureDetector(
      onTap: () {
        setState(() {
          aktivitet.done = !aktivitet.done;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 235, 235),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(),
                ),
                child: aktivitet.done
                ? const Icon(Icons.done)
                : null,
              ),
            ),
            Expanded(
              child: Text(
                aktivitet.titel,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.close, size: 30),
            ),
          ],
        ),
      )
    );
  }
}

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

