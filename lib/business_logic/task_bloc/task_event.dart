part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class FetchTaskEvent extends TaskEvent {
  FetchTaskEvent({this.skip});
  final int? skip;
}
