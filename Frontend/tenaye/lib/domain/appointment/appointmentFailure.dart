class AppointmentFailures implements Exception {
  final String message;

  AppointmentFailures(this.message);

  @override
  String toString() => 'AppointmentFailure: $message';
}
