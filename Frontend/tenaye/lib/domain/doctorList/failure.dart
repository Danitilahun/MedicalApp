import 'package:equatable/equatable.dart';

abstract class DoctorFailure extends Equatable {
  final String errorMessage;

  const DoctorFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class NotFoundFailure extends DoctorFailure {
  const NotFoundFailure(String errorMessage) : super(errorMessage);
}

class ServerFailure extends DoctorFailure {
  const ServerFailure(String errorMessage) : super(errorMessage);
}

class GenericFailure extends DoctorFailure {
  const GenericFailure(String errorMessage) : super(errorMessage);
}
