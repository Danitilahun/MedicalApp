import 'package:equatable/equatable.dart';
import 'package:tenaye/domain/rating/rating.dart';
import 'package:tenaye/domain/rating/failure.dart';

// Rating States
abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {
  final List<Rating> ratings;

  
  RatingSuccess(this.ratings);

  @override
  List<Object?> get props => [ratings];
}

class RatingFailure extends RatingState {
  final RatingException error;

  RatingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
