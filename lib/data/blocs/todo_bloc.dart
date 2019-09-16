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

  final _deletedTodoController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inDeleted => _deletedTodoController.sink;
  Stream<bool> get deleted => _deletedTodoController.stream;

  //PUT ToDos
  final _updateTodoController = StreamController<ToDo>.broadcast();
  StreamSink<ToDo> get inUpdateTodo => _updateTodoController.sink;

  final _updatedTodoController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inUpdated => _updatedTodoController.sink;
  Stream<bool> get updated => _updatedTodoController.stream;

  ToDoBloc() {
    getTodos();

    _addTodoController.stream.listen(_handleAddTodo);
    _deleteTodoController.stream.listen(_handleDeleteTodo);
    _updateTodoController.stream.listen(_handleUpdateTodo);
  }

  @override
  void dispose() {
    _todoController.close();
    _addTodoController.close();
    _addedTodoController.close();
    _deleteTodoController.close();
    _deletedTodoController.close();
    _updateTodoController.close();
    _updatedTodoController.close();
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
    _inDeleted.add(true);

    getTodos();
  }

  void _handleUpdateTodo(ToDo todo) async {
    await DBProvider.db.updateToDo(todo);
    _inUpdated.add(true);

    getTodos();
  }
}