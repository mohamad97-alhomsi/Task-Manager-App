import 'package:logger/logger.dart';
import 'package:task_manager_app/constants/api_constant.dart';
import 'package:task_manager_app/models/user_model.dart';
import 'package:task_manager_app/services/network_service/api_client.dart';

class AuthRepo {
  final _apiClient = ApiClient();
  Future login(UserModel userModel)async{
  try {
    final response = await _apiClient.post(ApiConstants.login,
    headers: {
      ApiConstants.contentType:ApiConstants.applicationJson,
      ApiConstants.accept:ApiConstants.applicationJson
    },
    body: userModel.toJson()
    );
    if(response.body!=null){
      return UserModel.fromJson(response.body);
    }
  } catch (e,stackTrace) {
    
    Logger().i(e);
    Logger().e(stackTrace);
    throw e;
  }
  }
}