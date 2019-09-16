import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sidebar.dart';
import '../data/blocs/todo_bloc.dart';
import '../data/blocs/bloc_provider.dart';
import '../models/todo_model.dart';
import 'editTodo.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selected = 0;
  var color = Color(0xffa5de16);
  ToDoBloc _todosBloc;

  @override
  void initState() {
    super.initState();

    _todosBloc = BlocProvider.of<ToDoBloc>(context);
  }

  String _handleTodoDate(String dueDate) {
    if (dueDate == '')
      return '-';
    else {
      final date = DateTime.parse(dueDate);

      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _handleLeadingIcon(ToDo todo) {
    if (todo.isDone == 1)
      return Icon(
        Icons.check,
        color: Colors.green,
      );

    MaterialColor color;

    switch (todo.evalDeadline()) {
      case DeadlineStatus.undefined:
        color = Colors.grey;
        break;
      case DeadlineStatus.farDeadline:
        color = Colors.green;
        break;
      case DeadlineStatus.nearDealine:
        color = Colors.yellow;
        break;
      case DeadlineStatus.overdue:
        color = Colors.red;
        break;
    }

    return Container(
        width: 20.0,
        height: 20.0,
        decoration: new BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ));
  }

  void _handleDoneUpdate(ToDo todo) {
    var newTodo = todo;
    newTodo.isDone = 1;

    _todosBloc.inUpdateTodo.add(newTodo);
  }

  Widget _handleSideBar(List<ToDo> todos, bool hasData){
    var numPending = 0, numOverdue = 0, numDone = 0;

    if(hasData)
      for(int i = 0; i < todos.length; i++)
        if(todos[i].isDone == 1)
          numDone++;
        else if(todos[i].evalDeadline() == DeadlineStatus.nearDealine || todos[i].evalDeadline() == DeadlineStatus.farDeadline || todos[i].evalDeadline() == DeadlineStatus.undefined)
          numPending++;
        else
          numOverdue++;

    return SideBar(numPending: numPending, numOverdue: numOverdue, numDone: numDone);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ToDo>>(
        stream: _todosBloc.todos,
        builder: (BuildContext context, AsyncSnapshot<List<ToDo>> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("ToDo App"),
            ),
            body: ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.length * 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index.isEven)
                    return ExpansionTile(
                      title: Text(snapshot.data[index ~/ 2].name,
                          style: TextStyle(fontSize: 18.0)),
                      leading: _handleLeadingIcon(snapshot.data[index ~/ 2]),
                      trailing: Text(''),
                      children: <Widget>[
                        ListTile(
                          title: Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                        Text('Descrição:',
                                            style: TextStyle(fontSize: 18.0)),
                                        Text(snapshot.data[index ~/ 2]
                                                    .description ==
                                                ''
                                            ? '-'
                                            : snapshot
                                                .data[index ~/ 2].description)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text('Data Limite:',
                                            style: TextStyle(fontSize: 18.0)),
                                        Text(
                                          _handleTodoDate(snapshot
                                              .data[index ~/ 2].dueDate),
                                          style: TextStyle(fontSize: 24.0),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: snapshot.data[index ~/ 2].isDone ==
                                          0
                                      ? <Widget>[
                                          InkWell(
                                            onTap: () {
                                              _handleDoneUpdate(
                                                  snapshot.data[index ~/ 2]);
                                            },
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 100.0, left: 100.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Provider<
                                                                ToDo>.value(
                                                              value: snapshot
                                                                      .data[
                                                                  index ~/ 2],
                                                              child: BlocProvider(
                                                                  child:
                                                                      EditToDoPage(),
                                                                  bloc:
                                                                      ToDoBloc()),
                                                            )));
                                              },
                                              child: Icon(Icons.edit,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _todosBloc.inDeleteTodo.add(
                                                  snapshot.data[index ~/ 2].id);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          )
                                        ]
                                      : <Widget>[
                                          InkWell(
                                            onTap: () {
                                              _todosBloc.inDeleteTodo.add(
                                                  snapshot.data[index ~/ 2].id);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  else
                    return Divider(height: 0.0);
                }),
            drawer: _handleSideBar(snapshot.data, snapshot.hasData),
          );
        });
  }
}

/*
*
* return Center(
              child: Column(
                children: <Widget>[
                  GestureDetector(
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
                        width: 200.0,
                        padding: EdgeInsets.all(12.0),
                        duration: Duration(milliseconds: 100),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text('Botão')),
                  )
                ],
              ),
            )*/
