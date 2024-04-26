part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}
 class AuthLoginEvent extends AuthEvent {
  final UserModel userData;
  AuthLoginEvent({required this.userData});
}
