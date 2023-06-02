// Events
import 'package:tenaye/domain/doctor/doctor.dart';

abstract class DoctorProfileEvent {}

class GetDoctorEvent extends DoctorProfileEvent {}

class UpdateProfileEvent extends DoctorProfileEvent {
  final Doctor doctor;

  UpdateProfileEvent(this.doctor);
}

class UpdateProfileImageEvent extends DoctorProfileEvent {
  final String imagePath;

  UpdateProfileImageEvent(this.imagePath);
}

class UpdateCertificateEvent extends DoctorProfileEvent {
  final String certificatePath;

  UpdateCertificateEvent(this.certificatePath);
}

class DeleteAccountEvent extends DoctorProfileEvent {}
