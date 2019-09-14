import 'package:flutter/material.dart';
import '../sidebar.dart';
import '../data/blocs/todo_bloc.dart';
import '../data/blocs/bloc_provider.dart';
import '../models/todo_model.dart';

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var color = Color(0xffa5de16);
  ToDoBloc _todosBloc;

  @override
  void initState() {
    super.initState();

    // Thanks to the BlocProvider providing this page with the NotesBloc,
    // we can simply use this to retrieve it.
    _todosBloc = BlocProvider.of<ToDoBloc>(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo App"),
      ),
      body: StreamBuilder<List<ToDo>>(
          stream: _todosBloc.todos,
          builder: (BuildContext context, AsyncSnapshot<List<ToDo>> snapshot) {
            return GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  color = Color(0xff6f960e);
                });
              },
              onTapUp: (TapUpDetails details) {
                setState(() {
                  color = Color(0xffa5de16);
                  print(snapshot.hasData);
                });
              },
              child: AnimatedContainer(
                  padding: EdgeInsets.all(12.0),
                  duration: Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text('Botão')),
            );
          }
      ),
      drawer: BlocProvider(child: SideBar(), bloc: ToDoBloc()), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



