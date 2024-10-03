import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './api.dart';
import './add_task.dart';

class MyState extends ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => _items;

  void setItems(List<Item> items) {
    _items = items;
    notifyListeners();
  }

  Future<void> fetchItems() async {
    ItemFetcher fetcher = ItemFetcher();
    List<Item> fetchedItems = await fetcher.fetchItems();
    setItems(fetchedItems);
  }

  Future<void> createItem(String title)  async {
    ItemCreator creator = ItemCreator();
    Item newItem = Item(title, false);
    await creator.createItem(newItem);
    await fetchItems();
  }

  Future<void> updateItem(Item item) async {
    ItemUpdater updater = ItemUpdater();
    await updater.updateItem(item);
    await fetchItems();
  }

  Future<void> deleteItem(String id) async {
    ItemDeleter deleter = ItemDeleter();
    await deleter.deleteItem(id);
    await fetchItems();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyState(),
      child: const MyApp(),
    )
  );
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String filter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchItems;
  }

  Future<void> _fetchItems() async {
    await Provider.of<MyState>(context, listen: false).fetchItems();
  }

List<Item> get filteredItems {
  final items = Provider.of<MyState>(context).items;
  if (filter == 'Completed') {
    return items.where((item) => item.done).toList();
  } else if (filter == 'Not Completed') {
    return items.where((item) => !item.done).toList();
  }
  return items;
}


void _removeTask(String id) {
    Provider.of<MyState>(context, listen: false).deleteItem(id);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text(
          'TIG333 TODO',
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
                value: 'All',
                child: Text('All'),
              ),
              const PopupMenuItem<String>(
                value: 'Completed',
                child: Text('Completed'),
              ),
              const PopupMenuItem<String>(
                value: 'Not Completed',
                child: Text('Not Completed'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchItems(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return _item(filteredItems[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          );
          if (result != null && result is String) {
            await Provider.of<MyState>(context, listen: false).createItem(result);
          }
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, size: 40, color: Colors.grey),
      ),
    );
  }

  Widget _item(Item item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          item.done = !item.done;
        });
        Provider.of<MyState>(context, listen: false).updateItem(item);
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
                child: item.done
                ? const Icon(Icons.done)
                : null,
              ),
            ),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  _removeTask(item.id!);
                },
                child: Icon(Icons.close, size: 30),
              ),
            )   
          ],
        ),
      )
    );
  }
}
