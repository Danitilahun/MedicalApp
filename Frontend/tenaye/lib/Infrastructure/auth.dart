import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/Infrastructure/local/tenayeDB.dart';
import 'package:tenaye/domain/auth/auth_failure.dart';
import 'package:tenaye/domain/user/user.dart';

class AuthDataProvider {
  final String _baseUrl = 'http://10.0.2.2:3000/api';

  late http.Client httpClient;
  late SharedPreferences sharedPreferences;

  TenayeDB tenaye = TenayeDB();

  AuthDataProvider() {
    httpClient = http.Client();
    SharedPreferences.getInstance().then((prefs) {
      sharedPreferences = prefs;
    });
  }

  Future<User?> register(String email, String password, String username) async {
    print(email);
    print(password);
    print(username);
    print("Registering in dataprovider...");
    final role = sharedPreferences.getString('role') ??
        'user'; // Get the role from shared preferences
    print("the role is");
    final response = await httpClient.post(
      Uri.parse('$_baseUrl/user/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
        'username': username,
        'roles': role, // Include the role in the request body
      }),
    );

    if (response.statusCode == 200) {
      // print(jsonDecode(response.body));
      try {
        final user = User.fromJson(jsonDecode(response.body));
        print("herrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
        print({"user", user.id});

        await tenaye.openDb();
        int? Id = await tenaye.insertUser(user);
        print("cached user: " + Id.toString());
        await saveTokens(user);
        return user;
      } catch (e) {
        print(e);
      }
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body)['message'];
      if (error == 'Email is already in use.') {
        throw EmailAlreadyInUseException();
      } else {
        throw AuthException(error);
      }
    } else if (response.statusCode == 500) {
      throw ServerErrorException();
    } else {
      throw NetworkErrorException();
    }
  }

  Future<User> login(String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('$_baseUrl/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      await tenaye.openDb();

      int? Id = await tenaye.insertUser(user);
      print("cached user: " + Id.toString());
      await saveTokens(user);
      return user;
    } else if (response.statusCode == 401) {
      throw AuthException('Invalid email or password.');
    } else if (response.statusCode == 500) {
      throw ServerErrorException();
    } else {
      throw NetworkErrorException();
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = '$_baseUrl/forgot-password';
    final response = await http.post(Uri.parse(url), body: {'email': email});
    if (response.statusCode != 200) {
      throw Exception('Failed to initiate password reset');
    }
  }

  Future<void> saveTokens(User user) async {
    await sharedPreferences.setString('refreshToken', user.refreshToken);
    await sharedPreferences.setString('accessToken', user.accessToken);
    await sharedPreferences.setString('userId', user.id);
    await sharedPreferences.setString('role', user.role);
    await sharedPreferences.setString('userRole', user.role);
  }

  Future<void> removeSavedUser() async {
    await sharedPreferences.remove('accessToken');
    await sharedPreferences.remove('refreshToken');
    await sharedPreferences.remove('userId');
    await sharedPreferences.remove('userRole');
    await sharedPreferences.remove('role');
  }

  Future<void> signOut() async {
    print("you are here: ");
    final refreshToken = sharedPreferences.getString('refreshToken') ?? '';
    print("signed out: ");
    final response = await httpClient.delete(
      Uri.parse('$_baseUrl/user/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      print("success");
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      await tenaye.openDb();
      int? Id = await tenaye.deleteUser(userId!);
      await removeSavedUser();
    } else {
      throw ServerErrorException();
    }
  }

  Future<String> getUserToken() async {
    return sharedPreferences.getString('accessToken') ?? '';
  }
}
