import 'package:tenaye/domain/user/user.dart';

abstract class ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final User user;

  ProfileLoadedState(this.user);
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState(this.message);
}

class ProfileDeletedState extends ProfileState {}

class ProfileUpdateInProgressState extends ProfileState {}

class ProfileUpdateSuccessState extends ProfileState {
  final User user;

  ProfileUpdateSuccessState(this.user);
}

class ProfileImageUpdateInProgressState extends ProfileState {}

class ProfileImageUpdateSuccessState extends ProfileState {
  final User user;

  ProfileImageUpdateSuccessState(this.user);
}

class AccountDeletionInProgressState extends ProfileState {}

class AccountDeletionSuccessState extends ProfileState {}

class ProfileFailureState extends ProfileState {
  final String message;

  ProfileFailureState(this.message);
}
