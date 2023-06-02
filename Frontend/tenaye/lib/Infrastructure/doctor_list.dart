import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/Infrastructure/local/tenayeDB.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/domain/doctorList/failure.dart';

class DoctorDataProvider {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  late SharedPreferences sharedPreferences;

  DoctorDataProvider() {
    initializeSharedPreferences();
  }

  Future<bool> checkLocalhostConnectivity() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000'))
          .timeout(Duration(seconds: 2));
      bool isConnected = response.statusCode == 200;

      await setPreference('useLocalData', !isConnected);

      return isConnected;
    } on SocketException catch (_) {
      print("asf");

      await setPreference('useLocalData', true);
      return false;
    } on TimeoutException catch (_) {
      await setPreference('useLocalData', true);
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> getPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<void> setPreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Map<String, String> _createHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final accessToken = sharedPreferences.getString('accessToken');

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  Map<String, dynamic> _createBodyWithUserRole() {
    final userRole = sharedPreferences.getString('userRole');

    return {
      'roles': userRole,
    };
  }

  Future<List<Doctor>?> fetchDoctors() async {
    bool isServerConnected = await checkLocalhostConnectivity();

    if (isServerConnected) {
      final headers = _createHeaders();
      final body = _createBodyWithUserRole();

      final response = await http.get(
        Uri.parse('$baseUrl/patient/doctors'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Doctor> doctors = responseData.map((item) {
          return Doctor.fromJson(item);
        }).toList();

        // Save the fetched doctors in the local SQL database
        print(doctors.toList());

        for (Doctor doctor in doctors) {
          print(doctor.id);
          await TenayeDB().openDb();
          await TenayeDB().insertDoctor(doctor);
        }
        return doctors;
      } else if (response.statusCode == 404) {
        throw NotFoundFailure('Doctors not found');
      } else {
        throw ServerFailure('Failed to fetch doctors');
      }
    } else {
      print(
          'No network connectivity. Retrieving doctors from local database...');
      // Retrieve doctors from local SQL database
      await TenayeDB().openDb();
      return TenayeDB().getDoctors();
    }
  }

  Future<Doctor> fetchDoctorDetails(String doctorId) async {
    final headers = _createHeaders();
    final body = _createBodyWithUserRole();
    print("doctor: " + doctorId);
    final response = await http.get(
      Uri.parse('$baseUrl/patient/doctor/$doctorId'),
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      return Doctor.fromJson(data);
    } else if (response.statusCode == 404) {
      throw NotFoundFailure('Doctor not found');
    } else {
      throw ServerFailure('Failed to fetch doctor details');
    }
  }

  Future<List<Doctor>> searchDoctors(String name) async {
    final headers = _createHeaders();
    final body = _createBodyWithUserRole();

    final response = await http.get(
      Uri.parse('$baseUrl/patient/doctors?name=$name'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Doctor> doctors =
          responseData.map((item) => Doctor.fromJson(item)).toList();

      // Filter doctors based on name match
      final List<Doctor> matchedDoctors = doctors.where((doctor) {
        final String doctorName = doctor.username!.toLowerCase();
        final String query = name.toLowerCase();
        return doctorName.contains(query);
      }).toList();

      if (matchedDoctors.isNotEmpty) {
        return matchedDoctors;
      } else {
        throw NotFoundFailure('Doctor not found');
      }
    } else if (response.statusCode == 404) {
      throw NotFoundFailure('Doctor not found');
    } else {
      throw ServerFailure('Failed to search for doctors');
    }
  }
}
