import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/Infrastructure/local/tenayeDB.dart';
import 'package:tenaye/domain/appointment/appointment.dart';
import 'package:tenaye/domain/appointment/appointmentFailure.dart';

class AppointmentDataProvider {
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

  Future<String?> _getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> _getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  Future<void> createAppointment(Appointment appointment) async {
    final String? userRole = await _getUserRole();
    final String apiEndpoint = (userRole == 'doctor') ? 'doctor' : 'patient';
    final String apiPath = '/$apiEndpoint/appointments';
    final String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw AppointmentFailures('Access token not available');
    }

    final Uri url = Uri.parse('$baseUrl$apiPath');

    final http.Response response = await http.post(
      url,
      body: jsonEncode(appointment.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 201) {
      throw AppointmentFailures('Failed to create appointment');
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    final String? userRole = await _getUserRole();
    final String apiEndpoint = (userRole == 'doctor') ? 'doctor' : 'patient';
    final String apiPath = '/$apiEndpoint/appointments/$appointmentId';

    final String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw AppointmentFailures('Access token not available');
    }

    final Uri url = Uri.parse('$baseUrl$apiPath');

    final http.Response response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 204) {
      throw AppointmentFailures('Failed to delete appointment');
    }
  }

  Future<List<Appointment>> getAppointments() async {
    bool isServerConnected = await checkLocalhostConnectivity();

    if (isServerConnected) {
      final String? userRole = await _getUserRole();
      final String? userId = await _getUserId();
      final String apiEndpoint = (userRole == 'doctor') ? 'doctor' : 'patient';
      final String apiPath = '/$apiEndpoint/appointments/$userId';

      final String? accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw AppointmentFailures('Access token not available');
      }

      final Uri url = Uri.parse('$baseUrl$apiPath');
      print(url.toString());
      final http.Response response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Appointment> appointments = jsonData
            .map((appointmentData) => Appointment.fromJson(appointmentData))
            .toList();

        // Save the fetched appointments in the local database
        await TenayeDB().openDb();
        for (Appointment appointment in appointments) {
          await TenayeDB().insertAppointment(appointment);
        }
        return appointments;
      } else {
        throw AppointmentFailures('Failed to get appointments');
      }
    } else {
      print(
          'No network connectivity. Retrieving appointments from local database...');
      // Retrieve appointments from local database
      await TenayeDB().openDb();
      return TenayeDB().getAppointments();
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    final String? userRole = await _getUserRole();
    final String apiEndpoint = (userRole == 'doctor') ? 'doctor' : 'patient';
    final String apiPath = '/$apiEndpoint/appointments/${appointment.id}';

    final String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw AppointmentFailures('Access token not available');
    }

    final Uri url = Uri.parse('$baseUrl$apiPath');

    print(url.toString());
    final http.Response response = await http.patch(
      url,
      body: jsonEncode(appointment.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw AppointmentFailures('Failed to update appointment');
    }
  }
}
