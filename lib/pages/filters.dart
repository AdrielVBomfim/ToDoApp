import 'package:flutter/material.dart';
import '../sidebar.dart';

class FiltersPage extends StatefulWidget {
  @override
  FiltersPageState createState() => FiltersPageState();
}

class FiltersPageState extends State<FiltersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo App"),
      ),
      body: Text("Filters"),
      drawer: SideBar(numPending: 0, numOverdue: 0, numDone: 0), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}