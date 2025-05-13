// TODO: TaskRepository combining API and local
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApiProvider {
  final _baseUrl = 'https://mockapi.io/api'; // Replace with your own mock URL

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse('$_baseUrl/tasks'));
    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      return jsonData.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    return Task.fromJson(json.decode(response.body));
  }

  Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('$_baseUrl/tasks/$id'));
  }

  Future<void> updateTask(Task task) async {
    await http.put(
      Uri.parse('$_baseUrl/tasks/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
  }
}
