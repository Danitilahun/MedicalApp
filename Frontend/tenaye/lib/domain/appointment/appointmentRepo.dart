import 'package:dartz/dartz.dart';
import 'package:tenaye/Infrastructure/appointment.dart';
import 'package:tenaye/domain/appointment/appointment.dart';
import 'package:tenaye/domain/appointment/appointmentFailure.dart';

class AppointmentRepository {
  final AppointmentDataProvider appointmentDataProvider =
      AppointmentDataProvider();

  AppointmentRepository();

  Future<Either<AppointmentFailures, void>> createAppointment(
      Appointment appointment) async {
    try {
      await appointmentDataProvider.createAppointment(appointment);
      return Right(null);
    } catch (e) {
      return Left(AppointmentFailures('Failed to create appointment: $e'));
    }
  }

  Future<Either<AppointmentFailures, void>> deleteAppointment(
      String appointmentId) async {
    try {
      await appointmentDataProvider.deleteAppointment(appointmentId);
      return Right(null);
    } catch (e) {
      return Left(AppointmentFailures('Failed to delete appointment: $e'));
    }
  }

  Future<Either<AppointmentFailures, List<Appointment>>>
      getAppointments() async {
    try {
      final List<Appointment> appointments =
          await appointmentDataProvider.getAppointments();
      return Right(appointments);
    } catch (e) {
      return Left(AppointmentFailures('Failed to get appointments: $e'));
    }
  }

  Future<Either<AppointmentFailures, void>> updateAppointment(
      Appointment appointment) async {
    try {
      await appointmentDataProvider.updateAppointment(appointment);
      return Right(null);
    } catch (e) {
      return Left(AppointmentFailures('Failed to update appointment: $e'));
    }
  }
}
