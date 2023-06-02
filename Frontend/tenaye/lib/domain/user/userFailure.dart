class UserFailure {
  final String message;

  UserFailure(this.message);

  @override
  String toString() {
    return 'UserFailure: $message';
  }
}

class UserNotFoundFailure extends UserFailure {
  UserNotFoundFailure() : super('User not found');
}

class ServerErrorFailure extends UserFailure {
  ServerErrorFailure() : super('Server error occurred');
}
