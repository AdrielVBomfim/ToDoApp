import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:date_util/date_util.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../data/blocs/todo_bloc.dart';
import '../data/blocs/bloc_provider.dart';

class EditToDoPage extends StatefulWidget {
  @override
  EditToDoPageState createState() => EditToDoPageState();
}

class EditToDoPageState extends State<EditToDoPage> {
  var saveColor = Color(0xFF4CAF50);

  var day = DateTime.now().day,
      month = DateTime.now().month,
      year = DateTime.now().year;

  bool ifDueDate = false, ifLoading = false;

  ToDo todo;
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

  void _handleInit(){
    todo = Provider.of<ToDo>(context);

    textName.text = todo.name;
    textDescription.text = todo.description;

    if (todo.dueDate != '') {
      ifDueDate = true;

      final dateParsed = DateTime.parse(todo.dueDate);

      _handleDateChange(dateParsed.day, dateParsed.month, dateParsed.year);
    }
  }

  void _handleEditToDo() {
    setState(() {
      DateTime time = DateTime.now();
      DateTime newTime = DateTime(year, month, day, time.hour, time.second,
          time.millisecond, time.microsecond);

      todo.name = textName.text;
      todo.description = textDescription.text;
      todo.dueDate = ifDueDate ? newTime.toString() : '';

      _todosBloc.inUpdateTodo.add(todo);
      
      _todosBloc.updated.listen((updated){
        if(updated){
          ifLoading = false;
          Navigator.of(context).pop(true);
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

  @override
  Widget build(BuildContext context) {
    if(todo == null)
      _handleInit();

    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo App"),
      ),
      body: StreamBuilder<List<ToDo>>(
          stream: _todosBloc.todos,
          builder: (BuildContext context, AsyncSnapshot<List<ToDo>> snapshot) {
            return SingleChildScrollView(
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
                            _handleEditToDo();
                          });
                          //_handleAddToDo(snapshot);
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
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: AnimatedOpacity(
                          opacity: ifLoading ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: CircularProgressIndicator()),
                    )
                  ],
                ),
              )
            ]));
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
