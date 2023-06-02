import 'package:tenaye/domain/user/user.dart';
import 'package:dartz/dartz.dart';
import 'package:tenaye/domain/user/userFailure.dart';

abstract class ProfileEvent {}

class GetUserEvent extends ProfileEvent {}


class UpdateProfileEvent extends ProfileEvent {
  final User user;

  UpdateProfileEvent(this.user);
}

class UpdateProfileImageEvent extends ProfileEvent {
  final String imagePath;

  UpdateProfileImageEvent(this.imagePath);
}

class DeleteAccountEvent extends ProfileEvent {}

class UserReceivedEvent extends ProfileEvent {
  final User user;

  UserReceivedEvent(this.user);
}

class UserUpdateSuccessEvent extends ProfileEvent {
  final User user;

  UserUpdateSuccessEvent(this.user);
}

class ProfileImageUpdateSuccessEvent extends ProfileEvent {
  final User user;

  ProfileImageUpdateSuccessEvent(this.user);
}

class DeleteAccountSuccessEvent extends ProfileEvent {}

class UserFailureEvent extends ProfileEvent {
  final UserFailure failure;

  UserFailureEvent(this.failure);
}
