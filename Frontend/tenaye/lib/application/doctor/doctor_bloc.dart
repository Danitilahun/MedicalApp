import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tenaye/Infrastructure/doctor.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/domain/doctor/doctorRepository.dart';
import 'package:tenaye/application/doctor/doctor_event.dart';
import 'package:tenaye/application/doctor/doctor_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final DoctorRepository doctorRepository = DoctorRepository();

  DoctorProfileBloc() : super(DoctorProfileLoadingState()) {
    on<GetDoctorEvent>(_getDoctorEvent);
    on<UpdateProfileEvent>(_updateProfileEvent);
    on<UpdateProfileImageEvent>(_updateProfileImageEvent);
    on<UpdateCertificateEvent>(_updateCertificateEvent);
    on<DeleteAccountEvent>(_deleteAccountEvent);
  }

  Future<void> _getDoctorEvent(
      GetDoctorEvent event, Emitter<DoctorProfileState> emit) async {
    emit(DoctorProfileLoadingState());
    final result = await doctorRepository.getDoctor();
    result.fold(
      (failure) => emit(DoctorProfileFailureState(failure.toString())),
      (doctor) => emit(DoctorProfileLoadedState(doctor)),
    );
  }

  Future<void> _updateProfileEvent(
      UpdateProfileEvent event, Emitter<DoctorProfileState> emit) async {
    emit(DoctorProfileUpdateInProgressState());
    final result = await doctorRepository.updateProfile(event.doctor);
    result.fold(
      (failure) => emit(DoctorProfileFailureState(failure.toString())),
      (updatedDoctor) => emit(DoctorProfileUpdateSuccessState(updatedDoctor)),
    );
  }

  Future<void> _updateProfileImageEvent(
      UpdateProfileImageEvent event, Emitter<DoctorProfileState> emit) async {
    emit(DoctorProfileImageUpdateInProgressState());
    final result = await doctorRepository.updateProfileImage(event.imagePath);
    result.fold(
      (failure) => emit(DoctorProfileFailureState(failure.toString())),
      (updatedDoctor) =>
          emit(DoctorProfileImageUpdateSuccessState(updatedDoctor)),
    );
  }

  Future<void> _updateCertificateEvent(
      UpdateCertificateEvent event, Emitter<DoctorProfileState> emit) async {
    emit(DoctorProfileCertificateUpdateInProgressState());
    final result =
        await doctorRepository.updateCertificate(event.certificatePath);
    result.fold(
      (failure) => emit(DoctorProfileFailureState(failure.toString())),
      (updatedDoctor) =>
          emit(DoctorProfileCertificateUpdateSuccessState(updatedDoctor)),
    );
  }

  Future<void> _deleteAccountEvent(
      DeleteAccountEvent event, Emitter<DoctorProfileState> emit) async {
    emit(DoctorProfileDeletionInProgressState());
    final result = await doctorRepository.deleteAccount();
    result.fold(
      (failure) => emit(DoctorProfileFailureState(failure.toString())),
      (_) => emit(DoctorProfileDeletionSuccessState()),
    );
  }
}
