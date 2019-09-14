import 'package:flutter/material.dart';
import 'color.dart';
import 'data/blocs/bloc_provider.dart';
import 'data/blocs/todo_bloc.dart';
import 'pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF00ACC1, color),
      ),
      home: BlocProvider(child: HomePage(), bloc: ToDoBloc()),
    );
  }
}
