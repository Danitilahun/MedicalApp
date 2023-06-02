import 'package:dartz/dartz.dart';
import 'package:tenaye/Infrastructure/doctor.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/domain/doctor/doctorFailure.dart';

class DoctorRepository {
  final DoctorDataProvider doctorDataProvider = DoctorDataProvider();

  DoctorRepository();

  Future<Either<DoctorFailure, Doctor>> getDoctor() async {
    try {
      final doctor = await doctorDataProvider.getDoctor();
      return Right(doctor);
    } catch (e) {
      return Left(DoctorFailure(e.toString()));
    }
  }

  Future<Either<DoctorFailure, Doctor>> updateProfile(Doctor doctor) async {
    try {
      final updatedDoctor = await doctorDataProvider.updateProfile(doctor);
      return Right(updatedDoctor);
    } catch (e) {
      return Left(DoctorFailure(e.toString()));
    }
  }

  Future<Either<DoctorFailure, Doctor>> updateProfileImage(
      String imagePath) async {
    try {
      final updatedDoctor =
          await doctorDataProvider.updateProfileImage(imagePath);
      return Right(updatedDoctor);
    } catch (e) {
      return Left(DoctorFailure(e.toString()));
    }
  }

  Future<Either<DoctorFailure, Doctor>> updateCertificate(
      String certificatePath) async {
    try {
      final updatedDoctor =
          await doctorDataProvider.updateCertificate(certificatePath);
      return Right(updatedDoctor);
    } catch (e) {
      return Left(DoctorFailure(e.toString()));
    }
  }

  Future<Either<DoctorFailure, void>> deleteAccount() async {
    try {
      await doctorDataProvider.deleteAccount();
      return Right(null);
    } catch (e) {
      return Left(DoctorFailure(e.toString()));
    }
  }
}
