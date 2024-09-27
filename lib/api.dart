import 'package:http/http.dart' as http;
import 'dart:convert';


const String ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';
const String KEY = 'f75a658b-5f5b-4b51-8bf9-1e786c766583';



class Item {
  final String title;
  bool done;
  final String? id;

  Item(this.title, this.done, [this.id]);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['title'], json['done'], json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
    };
  }
}


class ItemFetcher {
  Future<List<Item>> fetchItems() async {
    final response = await http.get(
      Uri.parse('$ENDPOINT/todos?key=$KEY'));
    List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map<Item>((json) {
      return Item(
        json['title'],
        json['done'],
        json['id'],
      );
    }).toList();
  }
}

class ItemCreator {
  Future<void> createItem(Item newItem) async {
    final response = await http.post(
      Uri.parse('$ENDPOINT/todos?key=$KEY'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(newItem.toJson()),
    );
  }
}

class ItemUpdater {
  Future<void> updateItem(Item updatedItem) async {
    final response = await http.put(
      Uri.parse('$ENDPOINT/todos/${updatedItem.id}?key=$KEY'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedItem.toJson()),
    );
  }
}

class ItemDeleter {
  Future<void> deleteItem(String id) async {
    final response = await http.delete(
      Uri.parse('$ENDPOINT/todos/$id?key=$KEY')
    );
  }
}