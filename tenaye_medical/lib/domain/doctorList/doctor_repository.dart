import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:tenaye/Infrastructure/doctor_list.dart';
import 'package:tenaye/domain/doctorList/doctor_profile.dart';
import 'package:tenaye/domain/doctorList/failure.dart';

class DoctorRepository {
  final DoctorDataProvider dataProvider;

  DoctorRepository() : dataProvider = DoctorDataProvider();

  Future<Either<DoctorFailure, List<Doctor>>> fetchDoctors() async {
    try {
      final doctors = await dataProvider.fetchDoctors();

      return Right(doctors);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch doctors'));
    }
  }

  Future<Either<DoctorFailure, Doctor>> fetchDoctorDetails(
      String doctorId) async {
    try {
      final doctor = await dataProvider.fetchDoctorDetails(doctorId);
      print("in repository");
      print(doctor);
      return Right(doctor);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch doctor details'));
    }
  }
}
