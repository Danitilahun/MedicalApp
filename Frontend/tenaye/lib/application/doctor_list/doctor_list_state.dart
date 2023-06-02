import 'package:equatable/equatable.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/domain/doctorList/failure.dart';

abstract class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object> get props => [];
}

class DoctorInitial extends DoctorState {}

class DoctorsLoading extends DoctorState {}

class DoctorsLoaded extends DoctorState {
  final List<Doctor> doctors;

  const DoctorsLoaded(this.doctors);

  @override
  List<Object> get props => [doctors];
}

class DoctorsLoadFailure extends DoctorState {
  final DoctorFailure failure;

  const DoctorsLoadFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class DoctorDetailsLoading extends DoctorState {}

class DoctorDetailsLoaded extends DoctorState {
  final Doctor doctor;

  const DoctorDetailsLoaded(this.doctor);

  @override
  List<Object> get props => [doctor];
}

class DoctorDetailsLoadFailure extends DoctorState {
  final DoctorFailure failure;

  const DoctorDetailsLoadFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class SearchLoading extends DoctorState {}

class SearchResultsLoaded extends DoctorState {
  final List<Doctor> searchResults;
  const SearchResultsLoaded(this.searchResults);
  @override
  List<Object> get props => [searchResults];
}

class SearchFailure extends DoctorState {
  final DoctorFailure failure;

  const SearchFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
