abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String role;
  final String id;

  Authenticated(this.role, this.id);
}

class UnAuthenticated extends AuthState {}

class AuthLoggingOut extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;

  AuthError(this.errorMessage);
}
