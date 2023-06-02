import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/domain/doctor/doctorFailure.dart';

class DoctorDataProvider {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

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

  Future<String?> getDoctorId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<Doctor> getDoctor() async {
    print("asf.csdmvcdflkjgvnmkcxblnj");
    try {
      final String? doctorId = await getDoctorId();
      final String? accessToken = await getAccessToken();

      if (doctorId == null || accessToken == null) {
        throw DoctorNotFoundFailure();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/doctor/profile/$doctorId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final doctorData = jsonDecode(response.body);
        print(Doctor.fromJson(doctorData));
        return Doctor.fromJson(doctorData);
      } else {
        throw ServerErrorFailure();
      }
    } catch (e) {
      throw DoctorFailure(e.toString());
    }
  }

  Future<Doctor> updateProfile(Doctor doctor) async {
    try {
      final String? doctorId = await getDoctorId();
      final String? accessToken = await getAccessToken();

      if (doctorId == null || accessToken == null) {
        throw DoctorNotFoundFailure();
      }

      final response = await http.put(
        Uri.parse('$baseUrl/doctor/profile/$doctorId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(doctor),
      );

      if (response.statusCode == 200) {
        final doctorData = jsonDecode(response.body);
        return Doctor.fromJson(doctorData);
      } else {
        throw ServerErrorFailure();
      }
    } catch (e) {
      throw DoctorFailure(e.toString());
    }
  }

  Future<Doctor> updateProfileImage(String imagePath) async {
    try {
      final String? doctorId = await getDoctorId();
      final String? accessToken = await getAccessToken();

      if (doctorId == null || accessToken == null) {
        throw DoctorNotFoundFailure();
      }

      final url = '$baseUrl/doctor/profileImage/$doctorId';
      final request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.files.add(await http.MultipartFile.fromPath(
        'profileImage',
        imagePath,
        contentType: MediaType('profileImage', path.extension(imagePath)),
      ));

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final doctorData = jsonDecode(response.body);
        var doctor = Doctor.fromJson(doctorData);
        imagePath = doctor.profileImage!;
        return doctor;
      } else {
        throw ServerErrorFailure();
      }
    } catch (e) {
      throw DoctorFailure(e.toString());
    }
  }

  Future<Doctor> updateCertificate(String certificatePath) async {
    try {
      final String? doctorId = await getDoctorId();
      final String? accessToken = await getAccessToken();

      if (doctorId == null || accessToken == null) {
        throw DoctorNotFoundFailure();
      }

      final url = '$baseUrl/doctor/certificate/$doctorId';
      final request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.files.add(await http.MultipartFile.fromPath(
        'certificate',
        certificatePath,
        contentType: MediaType('certificate', path.extension(certificatePath)),
      ));

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final doctorData = jsonDecode(response.body);
        return Doctor.fromJson(doctorData);
      } else {
        throw ServerErrorFailure();
      }
    } catch (e) {
      throw DoctorFailure(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      final String? doctorId = await getDoctorId();
      final String? accessToken = await getAccessToken();

      if (doctorId == null || accessToken == null) {
        throw DoctorNotFoundFailure();
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/doctor/deleteAccount/$doctorId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode != 204) {
        throw ServerErrorFailure();
      }
    } catch (e) {
      throw DoctorFailure(e.toString());
    }
  }
}
