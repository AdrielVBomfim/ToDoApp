import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../sidebar.dart';
import '../models/todo_model.dart';
import 'package:date_util/date_util.dart';
import '../data/blocs/todo_bloc.dart';
import '../data/blocs/bloc_provider.dart';

class AddToDoPage extends StatefulWidget {
  @override
  AddToDoPageState createState() => AddToDoPageState();
}

class AddToDoPageState extends State<AddToDoPage> {
  var saveColor = Color(0xFF4CAF50);
  var day = DateTime.now().day,
      month = DateTime.now().month,
      year = DateTime.now().year;
  bool ifDueDate = false, ifLoading = false;

  ToDoBloc _todosBloc;
  TextEditingController textName = new TextEditingController(),
      textDescription = new TextEditingController();

  @override
  void initState() {
    super.initState();

    // Thanks to the BlocProvider providing this page with the NotesBloc,
    // we can simply use this to retrieve it.
    _todosBloc = BlocProvider.of<ToDoBloc>(context);
  }

  void _handleAddToDo(AsyncSnapshot<List<ToDo>> snapshot) {
    setState(() {
      DateTime time = DateTime.now();
      DateTime newTime = DateTime(year, month, day, time.hour, time.second,
          time.millisecond, time.microsecond);
      ToDo temp = ToDo(
          id: DateTime.now().millisecondsSinceEpoch,
          name: textName.text,
          description: textDescription.text,
          dueDate: ifDueDate ? newTime.toString() : '',
          isDone: 0);

      _todosBloc.inAddTodo.add(temp);

      _todosBloc.added.listen((added) {
        if (added) {
          ifLoading = false;
          textName.clear();
          textDescription.clear();
        }
      });
    });
  }

  void _handleDateChange(int day, int month, int year) {
    //manipular atributo date do newToDo

    setState(() {
      if (DateUtil().daysInMonth(month, year) < day)
        this.day = DateUtil().daysInMonth(month, year);
      else
        this.day = day;

      this.month = month;
      this.year = year;
    });
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
            body: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 32.0, left: 8.0, right: 8.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                          labelText: 'Nome', border: OutlineInputBorder()),
                      child: TextField(
                          controller: textName,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration.collapsed(
                              hintText:
                              'Nome da sua nova tarefa (Campo Obrigatório)')),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 32.0, left: 8.0, right: 8.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                          labelText: 'Descrição', border: OutlineInputBorder()),
                      child: TextField(
                          maxLines: 5,
                          controller: textDescription,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration.collapsed(
                              hintText: 'Descrição da sua nova tarefa')),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 32.0),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                            value: ifDueDate,
                            onChanged: (value) {
                              setState(() {
                                ifDueDate = !ifDueDate;
                              });
                            }),
                        Text(
                          'Sua nova tarefa tem uma data limite?',
                          style: TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: !ifDueDate,
                    child: AnimatedOpacity(
                      opacity: ifDueDate ? 1.0 : 0.2,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        padding: EdgeInsets.only(top: 32.0, left: 8.0, right: 8.0),
                        child: InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Data Limite',
                                border: OutlineInputBorder()),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text('Dia',
                                            style: TextStyle(fontSize: 18.0)),
                                        NumberPicker.integer(
                                            initialValue: day,
                                            minValue: 1,
                                            maxValue:
                                            DateUtil().daysInMonth(month, year),
                                            onChanged: (newValue) =>
                                                _handleDateChange(
                                                    newValue, month, year))
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text('Mês',
                                            style: TextStyle(fontSize: 18.0)),
                                        NumberPicker.integer(
                                            initialValue: month,
                                            minValue: 1,
                                            maxValue: 12,
                                            onChanged: (newValue) =>
                                                _handleDateChange(
                                                    day, newValue, year))
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text('Ano',
                                            style: TextStyle(fontSize: 18.0)),
                                        NumberPicker.integer(
                                          initialValue: year,
                                          minValue: DateTime.now().year,
                                          maxValue: DateTime.now().year + 1000,
                                          onChanged: (newValue) =>
                                              _handleDateChange(
                                                  day, month, newValue),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.only(top: 32.0, left: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AbsorbPointer(
                          absorbing: ifLoading || textName.text == '',
                          child: GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              setState(() {
                                saveColor = Color(0xFF1B5E20);
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              setState(() {
                                saveColor = Color(0xFF4CAF50);
                                ifLoading = true;
                              });
                              _handleAddToDo(snapshot);
                            },
                            child: AnimatedContainer(
                                padding: EdgeInsets.all(12.0),
                                duration: Duration(milliseconds: 100),
                                decoration: BoxDecoration(
                                  color: saveColor,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text('Salvar',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Color(0xFFFFFFFF)))),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: AnimatedOpacity(
                              opacity: ifLoading ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 300),
                              child: CircularProgressIndicator()),
                        )
                      ],
                    ),
                  )
                ])),
            drawer: _handleSideBar(snapshot.data, snapshot.hasData),
          );
        });
  }
}
