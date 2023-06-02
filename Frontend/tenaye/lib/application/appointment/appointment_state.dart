import 'package:tenaye/domain/appointment/appointment.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentSuccess extends AppointmentState {
  final List<Appointment> appointments;

  AppointmentSuccess(this.appointments);
}

class AppointmentFailure extends AppointmentState {
  final String errorMessage;

  AppointmentFailure(this.errorMessage);
}

class AppointmentRescheduled extends AppointmentState {}

class AppointmentCancelled extends AppointmentState {}

class AppointmentClosed extends AppointmentState {}

class AppointmentCreated extends AppointmentState {}

class AppointmentDeleted extends AppointmentState {}

class AppointmentUpdated extends AppointmentState {}
