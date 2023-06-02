class DoctorFailure {
  final String message;

  DoctorFailure(this.message);

  @override
  String toString() {
    return 'DoctorFailure: $message';
  }
}

class DoctorNotFoundFailure extends DoctorFailure {
  DoctorNotFoundFailure() : super('Doctor not found');
}

class ServerErrorFailure extends DoctorFailure {
  ServerErrorFailure() : super('Server error occurred');
}
