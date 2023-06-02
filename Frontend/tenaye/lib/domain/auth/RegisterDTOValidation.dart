import 'package:dartz/dartz.dart';
import 'package:tenaye/domain/auth/RegisterDTO.dart';

class RegisterDTOValidation {
  static Either<String, RegisterDTO> validate(
      String email, String username, String password) {
    if (email.isEmpty) {
      return Left('Email is required.');
    }

    if (username.isEmpty) {
      return Left('Username is required.');
    }

    if (password.isEmpty) {
      return Left('Password is required.');
    }

    final emailValidation = _validateEmail(email);
    if (emailValidation.isLeft()) {
      return Left('Invalid email');
    }

    final usernameValidation = _validateUsername(username);
    if (usernameValidation.isLeft()) {
      return Left('Invalid username');
    }

    final passwordValidation = _validatePassword(password);
    if (passwordValidation.isLeft()) {
      return Left('Invalid password');
    }

    final dto =
        RegisterDTO(email: email, username: username, password: password);
    return Right(dto);
  }

  static Either<String, String> _validateEmail(String email) {
    final emailRegex = r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$';
    final RegExp regex = RegExp(emailRegex);
    if (!regex.hasMatch(email)) {
      return Left('Invalid email format.');
    }
    return Right(email);
  }

  static Either<String, String> _validateUsername(String username) {
    final usernameRegex = r'^[a-zA-Z][a-zA-Z0-9_]*$';
    final RegExp regex = RegExp(usernameRegex);
    if (!regex.hasMatch(username)) {
      return Left(
          'Invalid username format. Username should start with a letter and can contain letters, numbers, and underscores.');
    }
    return Right(username);
  }

  static Either<String, String> _validatePassword(String password) {
    final passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    final RegExp regex = RegExp(passwordRegex);
    if (!regex.hasMatch(password)) {
      return Left(
          'Invalid password format. Password must be at least 8 characters long and contain letters and numbers.');
    }
    return Right(password);
  }
}
