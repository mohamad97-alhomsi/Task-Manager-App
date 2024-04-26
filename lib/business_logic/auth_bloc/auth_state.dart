part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}
final class AuthLoadingState extends AuthState {}
final class AuthSuccessState extends AuthState {
  final UserModel user;
  AuthSuccessState({required this.user});
}
final class AuthErrorState extends AuthState {
  final Object ?error;
  final StackTrace ?stackTrace;
  AuthErrorState({this.error,this.stackTrace});
}
