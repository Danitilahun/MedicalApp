import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tenaye/domain/rating/rating.dart';
import 'package:tenaye/domain/rating/failure.dart';
import 'package:tenaye/Infrastructure/rating.dart';
import 'package:tenaye/domain/rating/rating_repositary.dart';
import 'rating_event.dart';
import 'rating_state.dart';

// Rating BLoC
class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository ratingRepository = RatingRepository();

  RatingBloc() : super(RatingInitial()) {
    
    on<PostRatingEvent>(_postRating);
    on<GetDoctorRatingsEvent>(_getDoctorRatings);
    on<DeleteRatingEvent>(_deleteRating);
    on<EditRatingEvent>(_editRating);
  }

  Future<void> _postRating(
      PostRatingEvent event, Emitter<RatingState> emit) async {
    emit(RatingLoading());

    final result = await ratingRepository.postRating(event.rating);
    result.fold(
      (failure) => emit(RatingFailure(GetDoctorRatingsException('$failure'))),
      (ratings) => emit(RatingSuccess([])),
    );
  }

  Future<void> _getDoctorRatings(
      GetDoctorRatingsEvent event, Emitter<RatingState> emit) async {
    emit(RatingLoading());
    final result = await ratingRepository.getDoctorRatings(event.doctorId);
    result.fold(
      (failure) => emit(RatingFailure(GetDoctorRatingsException('$failure'))),
      (ratings) => emit(RatingSuccess(ratings)),
    );
  }

  Future<void> _deleteRating(
      DeleteRatingEvent event, Emitter<RatingState> emit) async {
    emit(RatingLoading());
    try {
      await ratingRepository.deleteRating(event.ratingId);
      emit(RatingSuccess([]));
    } catch (e) {
      emit(RatingFailure(DeleteRatingException('$e')));
    }
  }

  Future<void> _editRating(
      EditRatingEvent event, Emitter<RatingState> emit) async {
    emit(RatingLoading());
    try {
      await ratingRepository.editRating(event.rating);
      emit(RatingSuccess([]));
    } catch (e) {
      emit(RatingFailure(EditRatingException(' $e')));
    }
  }
}
