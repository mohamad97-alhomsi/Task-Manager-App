class TaskModel {
  final List<Todo>? todos;
  final int? total;
  final int? skip;
  final int? limit;

  TaskModel({
    this.todos,
    this.total,
    this.skip,
    this.limit,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        todos: json["todos"] == null
            ? []
            : List<Todo>.from(json["todos"]!.map((x) => Todo.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );
}

class Todo {
  final int? id;
  final String? todo;
  final bool? completed;
  final int? userId;

  Todo({
    this.id,
    this.todo,
    this.completed,
    this.userId,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        todo: json["todo"],
        completed: json["completed"],
        userId: json["userId"],
      );
}
