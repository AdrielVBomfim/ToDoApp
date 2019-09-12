import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/todo_model.dart';

class DBProvider {
  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    // Get the location of our app directory. This is where files for our app,
    // and only our app, are stored. Files in this directory are deleted
    // when the app is deleted.
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'app.db');

    return await openDatabase(path, version: 1, onOpen: (db) async {
    }, onCreate: (Database db, int version) async {
      // Create the note table
      await db.execute('''
                CREATE TABLE todo(
                    id INTEGER PRIMARY KEY,
                    name TEXT DEFAULT '',
                    description TEXT DEFAULT '',
                    dueDate TEXT DEFAULT ''
                )
            ''');
    });
  }


  newNote(ToDo todo) async {
    final db = await database;
    var res = await db.insert('todo', todo.toJson());

    return res;
  }

  getNotes() async {
    final db = await database;
    var res = await db.query('todo');
    List<ToDo> todo = res.isNotEmpty ? res.map((todo) => ToDo.fromJson(todo)).toList() : [];

    return todo;
  }

  getNote(int id) async {
    final db = await database;
    var res = await db.query('todo', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ToDo.fromJson(res.first) : null;
  }

  updateNote(ToDo todo) async {
    final db = await database;
    var res = await db.update('todo', todo.toJson(), where: 'id = ?', whereArgs: [todo.id]);

    return res;
  }

  deleteNote(int id) async {
    final db = await database;

    db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}