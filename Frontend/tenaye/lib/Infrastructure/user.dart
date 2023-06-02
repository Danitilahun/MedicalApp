import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/Infrastructure/auth.dart';
import 'package:tenaye/Infrastructure/local/tenayeDB.dart';
import 'package:tenaye/domain/user/user.dart';
import 'package:tenaye/domain/user/userFailure.dart';

class UserDataProvider {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  late SharedPreferences sharedPreferences;

  UserDataProvider() {
    SharedPreferences.getInstance().then((prefs) {
      sharedPreferences = prefs;
    });
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

      await setPreference('useLocalData', true); // Use local data
      return false;
    } on TimeoutException catch (_) {
      await setPreference('useLocalData', true); // Use local data
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _printUsers() async {
    final String? userId = await getUserId();
    TenayeDB tenayeDB = TenayeDB();
    await tenayeDB.openDb();
    print("askfnsdkngvdlk");
    bool isConnected = await checkLocalhostConnectivity();
    if (!isConnected) {
      print('Unable to connect to localhost server');
    }
    print("object");
    if (userId != null) {
      User? user = await tenayeDB.getUser(userId);
      print(user);
    }
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<bool> getPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<void> setPreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> deletePreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<User> getUser() async {
    final String? userId = await getUserId();
    final String? accessToken = await getAccessToken();

    bool isServerConnected = await checkLocalhostConnectivity();
    if (isServerConnected) {
      print("Server is connected");
    } else {
      // Server is not running
      // Respond with a custom message or perform some other action
      print('Server is not running');
    }

    bool useLocalData = await getPreference('useLocalData');
    print(useLocalData);
    if (useLocalData) {
      await _printUsers();
    }

    if (userId == null || accessToken == null) {
      throw UserNotFoundFailure();
    }

    if (useLocalData) {
      TenayeDB tenayeDB = TenayeDB();
      await tenayeDB.openDb();
      User? user = await tenayeDB.getUser(userId);
      if (user != null) {
        return user;
      }
    }

    final response = await http.get(
      Uri.parse('$baseUrl/patient/profile/$userId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      User user = User.fromJson(userData);

      if (useLocalData) {
        TenayeDB tenayeDB = TenayeDB();
        await tenayeDB.openDb();
        await tenayeDB.updateUser(user);
      }

      return user;
    } else {
      throw ServerErrorFailure();
    }
  }

  Future<User> updateProfile(User user) async {
    try {
      final String? userId = await getUserId();
      final String? accessToken = await getAccessToken();
      bool useLocalData = await getPreference('useLocalData');

      if (userId == null || accessToken == null) {
        throw UserNotFoundFailure();
      }

      if (useLocalData) {
        TenayeDB tenayeDB = TenayeDB();
        await tenayeDB.openDb();
        await tenayeDB.updateUser(user);
      }

      final response = await http.put(
        Uri.parse('$baseUrl/patient/profile/$userId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toMap()),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        User user = User.fromJson(userData);

        if (useLocalData) {
          TenayeDB tenayeDB = TenayeDB();
          await tenayeDB.openDb();
          await tenayeDB.updateUser(user);
        }

        return user;
      } else {
        throw ServerErrorFailure();
      }
    } catch (e) {
      throw UserFailure(e.toString());
    }
  }

  Future<User> updateProfileImage(String imagePath) async {
    try {
      final String? userId = await getUserId();
      final String? accessToken = await getAccessToken();
      bool useLocalData = await getPreference('useLocalData');

      if (userId == null || accessToken == null) {
        throw UserNotFoundFailure();
      }

      final url = '$baseUrl/patient/profileImage/$userId';
      final request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.files.add(await http.MultipartFile.fromPath(
        'profileImage',
        imagePath,
        contentType: MediaType('profileImage', path.extension(imagePath)),
      ));

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        var user = User.fromJson(userData);

        return user;
      } else {
        throw ServerErrorFailure();
      }
    } catch (e) {
      throw UserFailure(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      final String? userId = await getUserId();
      final String? accessToken = await getAccessToken();
      bool useLocalData = await getPreference('useLocalData');

      if (userId == null || accessToken == null) {
        throw UserNotFoundFailure();
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/patient/deleteAccount/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      removeSavedUser();

      if (response.statusCode == 204) {
        if (useLocalData) {
          TenayeDB tenayeDB = TenayeDB();
          await tenayeDB.openDb();
          await tenayeDB.deleteUser(userId);
        }
      } else {
        throw ServerErrorFailure();
      }
    } catch (e) {
      throw UserFailure(e.toString());
    }
  }

  Future<void> removeSavedUser() async {
    await deletePreference('accessToken');
    await deletePreference('refreshToken');
    await deletePreference('userId');
    await deletePreference('userRole');
    await deletePreference('role');
  }
}
