import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();

  @override
  List<Object> get props => [];
}

class FetchDoctors extends DoctorEvent {}

class FetchDoctorDetails extends DoctorEvent {
  final String doctorId;

  const FetchDoctorDetails(this.doctorId);

  @override
  List<Object> get props => [doctorId];
}

class SearchDoctors extends DoctorEvent {
  final String query;

  const SearchDoctors(this.query);

  @override
  List<Object> get props => [query];
}
