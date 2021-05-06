import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/task.dart';

import 'models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, date TEXT, notify TEXT)",
        );
        await db.execute(
          "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)",
        );

        return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> updateTaskNotify(int id, String notify) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET notify = '$notify' WHERE id = '$id'");
  }

  Future<void> updateTaskDate(int id, String date) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET date = '$date' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE from tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE from todo WHERE taskId = '$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<List<Task>> getTask() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description'],
          date: taskMap[index]['date'],
          notify: taskMap[index]['notify']);
    });
  }

  Future<List<Todo>> getTodos(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery('SELECT * FROM todo WHERE taskId = $taskId');
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          taskId: todoMap[index]['taskId'],
          isDone: todoMap[index]['isDone']);
    });
  }
}