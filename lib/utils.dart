import 'package:todo_v2/todo.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Todo>> fetchTodos() async {
  final response = await http
      .get(Uri.parse('http://localhost:8080/todos'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Todo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return List<Todo>.from(
      (jsonDecode(response.body) as List<dynamic>).map((el) => Todo.fromJson(el))
    );
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Todo');
  }
}

Future<List<Todo>> createTodo(String task) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/todos'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'task': task,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<Todo>.from(
      (jsonDecode(response.body) as List<dynamic>).map((el) => Todo.fromJson(el))
    );
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to create Todo.');
  }
}

