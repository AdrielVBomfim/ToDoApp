import 'dart:async';

import 'bloc_provider.dart';
import '../database.dart';
import '../../models/todo_model.dart';

class ToDoBloc implements BlocBase{
  //GET ToDos
  final _todoController = StreamController<List<ToDo>>.broadcast();
  StreamSink<List<ToDo>> get _inTodos => _todoController.sink;
  Stream<List<ToDo>> get todos => _todoController.stream;

  //POST ToDos
  final _addTodoController = StreamController<ToDo>.broadcast();
  StreamSink<ToDo> get inAddTodo => _addTodoController.sink;

  final _addedTodoController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inAdded => _addedTodoController.sink;
  Stream<bool> get added => _addedTodoController.stream;

  //DELETE ToDos
  final _deleteTodoController = StreamController<int>.broadcast();
  StreamSink<int> get inDeleteTodo => _deleteTodoController.sink;

  ToDoBloc() {
    getTodos();

    _addTodoController.stream.listen(_handleAddTodo);
    _deleteTodoController.stream.listen(_handleDeleteTodo);
  }

  @override
  void dispose() {
    _todoController.close();
    _addTodoController.close();
    _addedTodoController.close();
    _deleteTodoController.close();
  }

  void getTodos() async {
    List<ToDo> todos = await DBProvider.db.getToDos();

    _inTodos.add(todos);
  }

  void _handleAddTodo(ToDo todo) async {
    await DBProvider.db.newToDo(todo);
    _inAdded.add(true);

    getTodos();
  }

  void _handleDeleteTodo(int id) async {
    await DBProvider.db.deleteToDo(id);

    getTodos();
  }
}