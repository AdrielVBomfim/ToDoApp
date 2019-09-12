import 'package:flutter/material.dart';
import '../sidebar.dart';

class AddToDoPage extends StatefulWidget {
  @override
  AddToDoPageState createState() => AddToDoPageState();
}

class AddToDoPageState extends State<AddToDoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo App"),
      ),
      body: Text("AddToDo"),
      drawer: SideBar(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}