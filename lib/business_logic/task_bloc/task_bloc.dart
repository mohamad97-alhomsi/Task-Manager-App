import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:task_manager_app/models/todo_model.dart';
import 'package:task_manager_app/repos/task_repo.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _taskRepo = TaskRepo();
  TaskBloc() : super(TaskInitialState()) {
    on<FetchTaskEvent>(_mapFetchTaskEventToState);
    on<AddTaskEvent>(_mapAddTaskEventToState);
    on<UpdateTaskEvent>(_mapUpdateTaskEventToState);
    on<DeleteTaskEvent>(_mapDeleteTaskEventToState);
  }
  _mapFetchTaskEventToState(
      FetchTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    try {
      TaskModel taskModel = await _taskRepo.fetchTasks(skip: event.skip ?? 10);
      emit(TaskSuccessState(taskModel: taskModel));
    } catch (e, stackTrace) {
      emit(TaskErrorState(error: e, stackTrace: stackTrace));
    }
  }
  _mapAddTaskEventToState(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    try {
      Todo todo = await _taskRepo.addTask(event.todoModel);
      emit(TaskSuccessState(taskModel: TaskModel(todos: [todo])));
    } catch (e, stackTrace) {
      emit(TaskErrorState(error: e, stackTrace: stackTrace));
    }
  }

  _mapUpdateTaskEventToState(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    try {
      Todo todo = await _taskRepo.updateTask(
          taskId: event.taskId, todoModel: event.todoModel);
      emit(TaskSuccessState(taskModel: TaskModel(todos: [todo])));
    } catch (e, stackTrace) {
      emit(TaskErrorState(error: e, stackTrace: stackTrace));
    }
  }

  _mapDeleteTaskEventToState(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    try {
      Todo todo = await _taskRepo.deleteTask(taskId: event.taskId);
      Logger().i(todo.toJson());
      emit(TaskSuccessState(taskModel: TaskModel(todos: [todo])));
    } catch (e, stackTrace) {
      emit(TaskErrorState(error: e, stackTrace: stackTrace));
    }
  }
}
