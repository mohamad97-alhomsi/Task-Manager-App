part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitialState extends TaskState {}

final class TaskLoadingState extends TaskState {}

final class TaskSuccessState extends TaskState {
  final TaskModel taskModel;
  TaskSuccessState({required this.taskModel});
}

final class TaskErrorState extends TaskState {
  final Object? error;
  final StackTrace? stackTrace;
  TaskErrorState({this.error, this.stackTrace});
}
