import 'package:mongo_dart/mongo_dart.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
  });
}

class TaskController {
  late Db _db;

  TaskController() {
    _db = Db('mongodb://localhost:27017/my_database');
    _db.open();
  }

  getTasks() async {
    // Implemente a lógica para recuperar tarefas do banco de dados
  }

  Future<void> addTask(Task task) async {
    // Implemente a lógica para adicionar uma nova tarefa ao banco de dados
  }

  Future<void> updateTask(Task task) async {
    // Implemente a lógica para atualizar uma tarefa no banco de dados
  }

  Future<void> deleteTask(String id) async {
    // Implemente a lógica para excluir uma tarefa do banco de dados
  }
}

class TaskViewModel {
  final TaskController _controller;

  TaskViewModel(this._controller);

  Future<List<Task>> getTasks() async {
    return await _controller.getTasks();
  }

  Future<void> addTask(Task task) async {
    await _controller.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _controller.updateTask(task);
  }

  Future<void> deleteTask(String id) async {
    await _controller.deleteTask(id);
  }
}
