import 'package:tenaye/domain/doctor/doctor.dart';

abstract class DoctorProfileState {}

class DoctorProfileLoadingState extends DoctorProfileState {}

class DoctorProfileLoadedState extends DoctorProfileState {
  final Doctor doctor;

  DoctorProfileLoadedState(this.doctor);
}

class DoctorProfileErrorState extends DoctorProfileState {
  final String message;

  DoctorProfileErrorState(this.message);
}

class DoctorProfileUpdateInProgressState extends DoctorProfileState {}

class DoctorProfileUpdateSuccessState extends DoctorProfileState {
  final Doctor doctor;

  DoctorProfileUpdateSuccessState(this.doctor);
}

class DoctorProfileImageUpdateInProgressState extends DoctorProfileState {}

class DoctorProfileImageUpdateSuccessState extends DoctorProfileState {
  final Doctor doctor;

  DoctorProfileImageUpdateSuccessState(this.doctor);
}

class DoctorProfileCertificateUpdateInProgressState
    extends DoctorProfileState {}

class DoctorProfileCertificateUpdateSuccessState extends DoctorProfileState {
  final Doctor doctor;

  DoctorProfileCertificateUpdateSuccessState(this.doctor);
}

class DoctorProfileDeletionInProgressState extends DoctorProfileState {}

class DoctorProfileDeletionSuccessState extends DoctorProfileState {}

class DoctorProfileFailureState extends DoctorProfileState {
  final String message;

  DoctorProfileFailureState(this.message);
}
