class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return 'Authentication Error: $message';
  }
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super('Email is already in use.');
}

class ServerErrorException extends AuthException {
  ServerErrorException() : super('Server error occurred.');
}

class NetworkErrorException extends AuthException {
  NetworkErrorException() : super('Network error occurred.');
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Invalid email or password.');
}
