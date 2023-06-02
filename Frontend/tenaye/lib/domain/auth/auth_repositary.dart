import 'package:dartz/dartz.dart';
import 'package:tenaye/Infrastructure/auth.dart';
import 'package:tenaye/domain/auth/LoginDTOValidation.dart';
import 'package:tenaye/domain/auth/RegisterDTOValidation.dart';
import 'package:tenaye/domain/auth/auth_failure.dart';
import 'package:tenaye/domain/user/user.dart';

class AuthRepository {
  final AuthDataProvider authDataProvider = AuthDataProvider();

  Future<Either<AuthException, User?>> register(
    String email,
    String password,
    String username,
  ) async {
    final validation =
        RegisterDTOValidation.validate(email, username, password);
    if (validation.isLeft()) {
      return Left(AuthException(validation.fold((error) => error, (_) => '')));
    }

    try {
      print({"in repo", email, password, username});
      final user = await authDataProvider.register(email, password, username);
      return Right(user);
    } catch (e) {
      return Left(AuthException('Registration failed: $e'));
    }
  }

  Future<Either<AuthException, User>> login(
      String email, String password) async {
    final validation = LoginDTOValidation.validate(email, password);
    if (validation.isLeft()) {
      return Left(AuthException(validation.fold((error) => error, (_) => '')));
    }

    try {
      final user = await authDataProvider.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(AuthException('Login failed: $e'));
    }
  }

  Future<Either<AuthException, void>> forgotPassword(String email) async {
    try {
      await authDataProvider.forgotPassword(email);
      return Right(null);
    } catch (e) {
      return Left(AuthException('Forgot password failed: $e'));
    }
  }

  Future<Either<AuthException, String>> getUserToken() async {
    try {
      final token = await authDataProvider.getUserToken();
      return Right(token);
    } catch (e) {
      return Left(AuthException('Failed to get user token: $e'));
    }
  }

  Future<void> signOut() async {
    await authDataProvider.signOut();
  }
}
