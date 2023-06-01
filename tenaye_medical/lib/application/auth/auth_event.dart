import 'package:equatable/equatable.dart';

abstract class AuthEvent {}

class LoggedIn extends AuthEvent {
  final String? role;
  final String? id;
  final String? token;

  LoggedIn({this.role, this.id, this.token});
}

class CheckLogIn extends AuthEvent {}

class LogOut extends AuthEvent {}
