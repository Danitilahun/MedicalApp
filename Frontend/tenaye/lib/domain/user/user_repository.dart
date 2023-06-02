import 'package:dartz/dartz.dart';
import 'package:tenaye/Infrastructure/user.dart';
import 'package:tenaye/domain/user/user.dart';
import 'package:tenaye/domain/user/userFailure.dart';

class UserRepository {
  final UserDataProvider userDataProvider = UserDataProvider();

  UserRepository();

  Future<Either<UserFailure, User>> getUser() async {
    try {
      final user = await userDataProvider.getUser();
      return Right(user);
    } catch (e) {
      return Left(UserFailure(e.toString()));
    }
  }

  Future<Either<UserFailure, User>> updateProfile(User user) async {
    try {
      final updatedUser = await userDataProvider.updateProfile(user);
      return Right(updatedUser);
    } catch (e) {
      return Left(UserFailure(e.toString()));
    }
  }

  Future<Either<UserFailure, User>> updateProfileImage(String imagePath) async {
    try {
      final updatedUser = await userDataProvider.updateProfileImage(imagePath);
      return Right(updatedUser);
    } catch (e) {
      return Left(UserFailure(e.toString()));
    }
  }

  Future<Either<UserFailure, void>> deleteAccount() async {
    try {
      await userDataProvider.deleteAccount();
      return Right(null);
    } catch (e) {
      return Left(UserFailure(e.toString()));
    }
  }
}
