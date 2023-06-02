import 'package:bloc/bloc.dart';
import 'package:tenaye/domain/auth/RegisterDTO.dart';
import 'package:tenaye/domain/auth/auth_failure.dart';
import 'package:tenaye/domain/auth/auth_repositary.dart';
import 'package:tenaye/domain/user/user.dart';

import 'register_state.dart';
import 'register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository = AuthRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());

      if (event.password != event.confirmPassword) {
        emit(RegisterFailure('Passwords do not match.'));
        return;
      }

      final RegisterDTO registerDTO = RegisterDTO(
        email: event.email,
        password: event.password,
        username: event.username,
      );

      print(registerDTO);

      try {
        final result = await authRepository.register(
          registerDTO.email,
          registerDTO.password,
          registerDTO.username,
        );

        result.fold(
          (failure) {
            if (failure is EmailAlreadyInUseException) {
              emit(RegisterFailure('Email is already in use.'));
            } else if (failure is ServerErrorException) {
              emit(RegisterFailure('Server error occurred.'));
            } else if (failure is NetworkErrorException) {
              emit(RegisterFailure('Network error occurred.'));
            } else {
              emit(RegisterFailure(failure.message));
            }
          },
          (user) => emit(RegisterSuccess()),
        );
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
