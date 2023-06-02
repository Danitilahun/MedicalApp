import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:tenaye/domain/user/user.dart';
import 'package:tenaye/domain/user/userFailure.dart';
import 'package:tenaye/domain/user/user_repository.dart';
import 'package:tenaye/application/user/user_event.dart';
import 'package:tenaye/application/user/user_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository = UserRepository();

  ProfileBloc() : super(ProfileLoadingState()) {
    
    on<GetUserEvent>(_getUserEvent);
    on<UpdateProfileEvent>(_updateProfileEvent);
    on<UpdateProfileImageEvent>(_updateProfileImageEvent);
    on<DeleteAccountEvent>(_deleteAccountEvent);
  }

  Future<void> _getUserEvent(
      GetUserEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await userRepository.getUser();
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (user) => emit(ProfileLoadedState(user)),
    );
  }

  Future<void> _updateProfileEvent(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await userRepository.updateProfile(event.user);
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (user) => emit(ProfileLoadedState(user)),
    );
  }

  Future<void> _updateProfileImageEvent(
      UpdateProfileImageEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await userRepository.updateProfileImage(event.imagePath);
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (user) => emit(ProfileLoadedState(user)),
    );
  }

  Future<void> _deleteAccountEvent(
      DeleteAccountEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    final result = await userRepository.deleteAccount();
    result.fold(
      (failure) => emit(ProfileErrorState(failure.message)),
      (_) => emit(ProfileDeletedState()),
    );
  }
}
