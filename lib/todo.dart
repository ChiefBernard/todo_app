class Todo {
  final int id;
  final String task;
  final bool completed;

  const Todo({
    required this.id,
    required this.task,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'task': String task,
        'completed': bool completed,
      } =>
        Todo(
          id: id,
          task: task,
          completed: completed,
        ),
      _ => throw const FormatException('Failed to parse Todo.'),
    };
  }
}

