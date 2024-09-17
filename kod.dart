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

class Aktivitet {
  final String name;
  final String role;

  Aktivitet(this.name, this.role);
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Aktivitet> aktiviteter = [
      Aktivitet('Diska', '9 September'),
      Aktivitet('Städa', '11 September'),
      Aktivitet('Diska', '20 September'),
      Aktivitet('Tvätta', '2 September'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Påminnelser', 
        style: TextStyle(fontSize: 32)), 
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: <Color> [
                  Color.fromARGB(255, 164, 78, 134), 
                  Color.fromARGB(255, 230, 171, 240)]),
          )
        )
      ),
body: ListView(
  children: 
    aktiviteter.map((aktivitet) => Padding(
      padding: const EdgeInsets.all(2.0),
      child: _item(aktivitet.name, aktivitet.role),
      )
    ).toList(),
),
    );
  }

Widget _item(String name, String role) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 235, 235, 235),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(18),
          child: Container(
          width: 25, 
          height: 25,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(15),
              border: Border.all(
              color: Colors.black
            )
          ),
        ),
      ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                role,
                style: TextStyle(fontSize: 15)
              ),
            ],
          ),  
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(
            Icons.close, 
            size: 30
            ),
          )
        ],
    ),
  );
}

}
