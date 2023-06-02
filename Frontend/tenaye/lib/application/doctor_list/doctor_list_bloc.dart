import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tenaye/application/doctor_list/doctor_list_event.dart';
import 'package:tenaye/application/doctor_list/doctor_list_state.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/domain/doctorList/doctor_repository.dart';
import 'package:tenaye/domain/doctorList/failure.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorRepository doctorRepository = DoctorRepository();

  DoctorBloc() : super(DoctorInitial()) {
    on<FetchDoctors>(_mapFetchDoctorsToState);
    on<FetchDoctorDetails>(_mapFetchDoctorDetailsToState);
    on<SearchDoctors>(_mapSearchDoctorsToState);
  }

  Future<void> _mapFetchDoctorsToState(
      FetchDoctors event, Emitter<DoctorState> emit) async {
    emit(DoctorsLoading());
    try {
      final Either<DoctorFailure, List<Doctor>> result =
          await doctorRepository.fetchDoctors();
      result.fold(
        (DoctorFailure failure) {
          emit(DoctorsLoadFailure(failure)); // Emit failure state
        },
        (List<Doctor> doctors) {
          emit(DoctorsLoaded(doctors)); // Emit success state with doctors list
        },
      );
    } catch (e) {
      emit(DoctorsLoadFailure(GenericFailure("Failed to fetch doctors")));
    }
  }

  Future<void> _mapFetchDoctorDetailsToState(
      FetchDoctorDetails event, Emitter<DoctorState> emit) async {
    emit(DoctorDetailsLoading());
    try {
      print(event.doctorId);
      final Either<DoctorFailure, Doctor> result =
          await doctorRepository.fetchDoctorDetails(event.doctorId);
      result.fold(
        (DoctorFailure failure) {
          if (failure is NotFoundFailure) {
            emit(DoctorDetailsLoadFailure(NotFoundFailure("Doctor not found")));
          } else if (failure is ServerFailure) {
            emit(DoctorDetailsLoadFailure(ServerFailure("Server error")));
          } else {
            emit(DoctorDetailsLoadFailure(
                GenericFailure("Failed to fetch doctor details")));
          }
        },
        (Doctor doctor) {
          emit(DoctorDetailsLoaded(
              doctor)); // Emit success state with doctor details
        },
      );
    } catch (e) {
      emit(DoctorDetailsLoadFailure(
          GenericFailure("Failed to fetch doctor details")));
    }
  }

  Future<void> _mapSearchDoctorsToState(
    SearchDoctors event,
    Emitter<DoctorState> emit,
  ) async {
    emit(SearchLoading()); // Emit a loading state specifically for search

    try {
      final Either<DoctorFailure, List<Doctor>> result =
          await doctorRepository.searchDoctors(event.query);
      result.fold(
        (DoctorFailure failure) {
          emit(SearchFailure(failure)); // Emit failure state
        },
        (List<Doctor> searchResults) {
          emit(SearchResultsLoaded(
              searchResults)); // Emit success state with search results
        },
      );
    } catch (e) {
      emit(SearchFailure(ServerFailure("Failed to search doctors")));
    }
  }
}
