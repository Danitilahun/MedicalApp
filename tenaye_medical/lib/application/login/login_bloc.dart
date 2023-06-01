import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tenaye/application/login/login_event.dart';
import 'package:tenaye/application/login/login_state.dart';
import 'package:tenaye/domain/auth/LoginDTO.dart';
import 'package:tenaye/domain/auth/auth_failure.dart';
import 'package:tenaye/domain/auth/auth_repositary.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository = AuthRepository();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      final LoginDTO loginDTO = LoginDTO(
        email: event.email,
        password: event.password,
      );

      try {
        final result = await authRepository.login(
          loginDTO.email,
          loginDTO.password,
        );

        result.fold(
          (failure) {
            if (failure is InvalidCredentialsException) {
              emit(LoginFailure('Invalid email or password.'));
            } else if (failure is ServerErrorException) {
              emit(LoginFailure('Server error occurred.'));
            } else if (failure is NetworkErrorException) {
              emit(LoginFailure('Network error occurred.'));
            } else {
              emit(LoginFailure(failure.message));
            }
          },
          (user) => emit(LoginSuccess()),
        );
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
