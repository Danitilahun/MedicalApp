import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/Infrastructure/auth.dart';
import 'package:tenaye/application/auth/auth_event.dart';
import 'package:tenaye/application/auth/auth_state.dart';
import 'package:tenaye/domain/auth/auth_repositary.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late SharedPreferences sharedPreferences;
  final AuthRepository authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    initializeSharedPreferences();
    on<CheckLogIn>((event, emit) async {
      final bool hasToken = sharedPreferences.containsKey('accessToken');
      if (hasToken) {
        final String? accessToken = sharedPreferences.getString('accessToken');
        final String? id = sharedPreferences.getString('id');
        final String? role = sharedPreferences.getString('userRole');
        emit(Authenticated(role!, id!));
      }
    });

    on<LoggedIn>(
      (event, emit) async {
        emit(AuthLoading());
        await sharedPreferences.setString('id', event.id!);
        await sharedPreferences.setString('accessToken', event.token!);
        await sharedPreferences.setString('role', event.role!);
        emit(Authenticated(event.role!, event.id!));
      },
    );

    on<LogOut>(
      (event, emit) async {
        emit(AuthLoggingOut());
        try {
          await authRepository.signOut();
          emit(AuthInitial());
        } catch (e) {
          emit(AuthError('Failed to log out: $e'));
        }
      },
    );
  }

  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}
