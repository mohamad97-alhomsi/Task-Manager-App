import 'package:logger/logger.dart';
import 'package:task_manager_app/constants/api_constant.dart';
import 'package:task_manager_app/models/todo_model.dart';
import 'package:task_manager_app/services/network_service/api_client.dart';

class TaskRepo {
  final _apiClient = ApiClient();

  Future fetchTasks({int skip = 10}) async {
    try {
      var response = await _apiClient.get(ApiConstants.todo,
          parameters: {"limit": "10", "skip": skip.toString()});
      if (response.body != null) {
        return TaskModel.fromJson(response.body);
      }
    } catch (e, stackTrace) {
      Logger().e(stackTrace);
    }
  }
}
