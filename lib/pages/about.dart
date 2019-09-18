import 'package:flutter/material.dart';
import '../sidebar.dart';

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo App"),
      ),
      body: Text("About"),
      drawer: SideBar(todos: [],hasTodos: false), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}