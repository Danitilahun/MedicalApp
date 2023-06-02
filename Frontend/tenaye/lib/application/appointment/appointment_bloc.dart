import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/appointment/appointment_event.dart';
import 'package:tenaye/application/appointment/appointment_state.dart';
import 'package:tenaye/domain/appointment/appointment.dart';
import 'package:tenaye/domain/appointment/appointmentFailure.dart';
import 'package:tenaye/domain/appointment/appointmentRepo.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository = AppointmentRepository();

  AppointmentBloc() : super(AppointmentInitial()) {
    on<BookAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());

      final result =
          await appointmentRepository.createAppointment(event.appointment);

      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (_) => emit(AppointmentCreated()),
      );
    });

    on<GetAppointmentsEvent>((event, emit) async {
      emit(AppointmentLoading());

      final result = await appointmentRepository.getAppointments();

      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (appointments) => emit(AppointmentSuccess(appointments)),
      );
    });

    on<RescheduleAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());
      print(event.appointment);
      final result =
          await appointmentRepository.updateAppointment(event.appointment);

      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (_) => emit(AppointmentRescheduled()),
      );
    });

    on<CancelAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());

      final result =
          await appointmentRepository.deleteAppointment(event.appointmentId);

      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (_) => emit(AppointmentCancelled()),
      );
    });

    on<CloseAppointmentEvent>((event, emit) async {
      emit(AppointmentLoading());

      final result =
          await appointmentRepository.deleteAppointment(event.appointmentId);

      result.fold(
        (failure) => emit(AppointmentFailure(failure.message)),
        (_) => emit(AppointmentClosed()),
      );
    });
  }
}
