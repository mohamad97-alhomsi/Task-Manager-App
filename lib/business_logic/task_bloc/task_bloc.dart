import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager_app/models/todo_model.dart';
import 'package:task_manager_app/repos/task_repo.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _taskRepo = TaskRepo();
  TaskBloc() : super(TaskInitialState()) {
    on<FetchTaskEvent>(_mapFetchTaskEventToState);
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
}
