part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class FetchTaskEvent extends TaskEvent {
  FetchTaskEvent({this.skip});
  final int? skip;
}
class AddTaskEvent extends TaskEvent {
  AddTaskEvent({required this.todoModel});

  final Todo todoModel;
}

class DeleteTaskEvent extends TaskEvent {
  DeleteTaskEvent({required this.taskId});
  final int taskId;
}

class UpdateTaskEvent extends TaskEvent {
  UpdateTaskEvent({required this.taskId, required this.todoModel});
  final int taskId;
  final Todo todoModel;
}

