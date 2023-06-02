// Define the events
import 'package:tenaye/domain/appointment/appointment.dart';

abstract class AppointmentEvent {}

class BookAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;

  BookAppointmentEvent(this.appointment);
}

class GetAppointmentsEvent extends AppointmentEvent {}

class RescheduleAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;

  RescheduleAppointmentEvent(this.appointment);
}

class CancelAppointmentEvent extends AppointmentEvent {
  final String appointmentId;

  CancelAppointmentEvent(this.appointmentId);
}

class CloseAppointmentEvent extends AppointmentEvent {
  final String appointmentId;

  CloseAppointmentEvent(this.appointmentId);
}
