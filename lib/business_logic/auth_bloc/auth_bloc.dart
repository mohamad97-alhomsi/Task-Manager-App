import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:task_manager_app/models/user_model.dart';
import 'package:task_manager_app/repos/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authRepo = AuthRepo();
  AuthBloc() : super(AuthInitialState()) {
 on<AuthLoginEvent>(_mapLoginEventToState);
  }
   _mapLoginEventToState( AuthLoginEvent event, Emitter<AuthState> emit)async{
    emit(AuthLoadingState());
    try {
         var loginData = await _authRepo.login(event.userData);
         if (loginData!=null){
          emit(AuthSuccessState(user: loginData));
         }else {
          Logger().i(loginData);
          emit(AuthErrorState(error: loginData));
         }
    } catch (e,stackTrace) {
      emit(AuthErrorState(error: e,stackTrace:stackTrace ));
    }
   
    }
}
