import 'package:flutter/material.dart';
import 'color.dart';
import 'pages/about.dart';
import 'pages/addToDo.dart';
import 'pages/filters.dart';
import 'pages/home.dart';
import 'data/blocs/bloc_provider.dart';
import 'data/blocs/todo_bloc.dart';
import 'models/todo_model.dart';

enum Pages { Home, AddToDo, Filters, About }

class SideBar extends StatelessWidget {
  final todos, hasTodos;
  var numPending = 0, numOverdue = 0, numDone = 0;

  SideBar({this.todos, this.hasTodos}){
    if(hasTodos)
      for(int i = 0; i < todos.length; i++)
        if(todos[i].isDone == 1)
          numDone++;
        else if(todos[i].evalDeadline() == DeadlineStatus.nearDealine || todos[i].evalDeadline() == DeadlineStatus.farDeadline || todos[i].evalDeadline() == DeadlineStatus.undefined)
          numPending++;
        else
          numOverdue++;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          new DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Tarefas Pendentes: $numPending",
                    style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF))),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Text("Tarefas Atrasadas: $numOverdue",
                    style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF))),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Text("Tarefas Concluidas: $numDone",
                    style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)))
              ],
            ),
            decoration:
            new BoxDecoration(color: MaterialColor(0xFF00ACC1, color)),
          ),
          ListTile(
            title: Text("Home", style: TextStyle(fontSize: 16)),
            trailing: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pop();

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      BlocProvider(child: HomePage(), bloc: ToDoBloc())));
            },
          ),
          ListTile(
              title: Text("Adicionar Tarefa", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.add),
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BlocProvider(child: AddToDoPage(), bloc: ToDoBloc())));
              }),
          ListTile(
              title: Text("Filtros", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.filter_list),
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BlocProvider(child: FiltersPage(), bloc: ToDoBloc())));
              }),
          ListTile(
              title: Text("Sobre", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.info),
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BlocProvider(child: AboutPage(), bloc: ToDoBloc())));
              }),
        ],
      ),
    );
  }
}
