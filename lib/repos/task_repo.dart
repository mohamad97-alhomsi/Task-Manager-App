import 'package:logger/logger.dart';
import 'package:task_manager_app/constants/api_constant.dart';
import 'package:task_manager_app/models/todo_model.dart';
import 'package:task_manager_app/services/network_service/api_client.dart';

class TaskRepo {
  final _apiClient = ApiClient();

  Future fetchTasks({int skip = 10}) async {
    try {
      var response = await _apiClient.get(ApiConstants.getTodos,
          parameters: {"limit": "10", "skip": skip.toString()},
          headers: {ApiConstants.contentType: ApiConstants.applicationJson});
      Logger().i(response.body);
      if (response.body != null) {
        return TaskModel.fromJson(response.body);
      }
    } catch (e, stackTrace) {
      Logger().e(stackTrace);
    }
  }

  Future addTask(Todo todoModel) async {
    try {
      var response = await _apiClient.post(ApiConstants.addTodo,
          body: todoModel.toJson(),
          headers: {ApiConstants.contentType: ApiConstants.applicationJson});
      Logger().i(response.body);
      if (response.body != null) {
        return Todo.fromJson(response.body);
      }
    } catch (e, stackTrace) {
      Logger().e(stackTrace);
    }
  }

  Future deleteTask({required int taskId}) async {
    try {
      var response = await _apiClient.delete(
          "${ApiConstants.deleteTodo}$taskId",
          headers: {ApiConstants.contentType: ApiConstants.applicationJson});
      Logger().i(response.body);
      if (response.body != null) {
        return Todo.fromJson(response.body);
      }
    } catch (e, stackTrace) {
      Logger().e(stackTrace);
    }
  }

  Future updateTask({required int taskId, required Todo todoModel}) async {
    try {
      var response = await _apiClient.update(
          "${ApiConstants.updateTodo}$taskId",
          headers: {ApiConstants.contentType: ApiConstants.applicationJson},
          body: todoModel.toJson());
      Logger().i(response.body);
      if (response.body != null) {
        return Todo.fromJson(response.body);
      }
    } catch (e, stackTrace) {
      Logger().e(stackTrace);
    }
  }
}
