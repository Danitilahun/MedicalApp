import 'package:equatable/equatable.dart';
import 'package:tenaye/domain/rating/rating.dart';

// Rating Events
abstract class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object?> get props => [];
}


class PostRatingEvent extends RatingEvent {
  final Rating rating;

  PostRatingEvent(this.rating);

  @override
  List<Object?> get props => [rating];
}

class GetDoctorRatingsEvent extends RatingEvent {
  final String doctorId;

  GetDoctorRatingsEvent(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

class DeleteRatingEvent extends RatingEvent {
  final String ratingId;

  DeleteRatingEvent(this.ratingId);

  @override
  List<Object?> get props => [ratingId];
}

class EditRatingEvent extends RatingEvent {
  final Rating rating;

  EditRatingEvent(this.rating);

  @override
  List<Object?> get props => [rating];
}
