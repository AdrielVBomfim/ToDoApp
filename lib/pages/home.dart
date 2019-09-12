import 'package:flutter/material.dart';
import '../sidebar.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo App"),
      ),
      body: Text("Home"),
      drawer: SideBar(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}