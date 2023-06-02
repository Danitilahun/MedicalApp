class RatingException implements Exception {
  final String message;

  RatingException(this.message);

  @override
  String toString() => 'RatingException: $message';
}

class PostRatingException extends RatingException {
  PostRatingException(String message) : super(message);
}

class GetDoctorRatingsException extends RatingException {
  GetDoctorRatingsException(String message) : super(message);
}


class EditRatingException extends RatingException {
  EditRatingException(String message) : super(message);
}

class DeleteRatingException extends RatingException {
  DeleteRatingException(String message) : super(message);
}
