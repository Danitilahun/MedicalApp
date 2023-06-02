import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/domain/rating/failure.dart';
import 'package:tenaye/domain/rating/rating.dart';

class RatingDataProvider {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<String?> _getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
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

  Future<void> postRating(Rating rating) async {
    // ...

    final String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw PostRatingException('Access token not available');
    }

    final Uri url = Uri.parse('$baseUrl/patient/ratings');
    print("new rating");
    print(url.toString());

    final http.Response response = await http.post(
      url,
      body: jsonEncode(rating.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 201) {
      // Rating successfully posted
    } else if (response.statusCode == 500) {
      throw PostRatingException("Server error");
    } else if (response.statusCode == 400) {
      throw PostRatingException(
          "You cannot rate a doctor you did not have an appointment with.");
    } else {
      throw PostRatingException("Failed to post rating");
    }
  }

  // Future<void> postRating(Rating rating) async {
  //   final String? accessToken = await _getAccessToken();
  //   if (accessToken == null) {
  //     throw PostRatingException('Access token not available');
  //   }

  //   final Uri url = Uri.parse('$baseUrl/patient/ratings');
  //   print("new rating");
  //   print(url.toString());
  //   final http.Response response = await http.post(
  //     url,
  //     body: jsonEncode(rating.toJson()),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );
  //   print(response.statusCode);
  //   if (response.statusCode == 201) {
  //   } else if (response.statusCode == 500) {
  //     PostRatingException("Server error");
  //   } else if (response.statusCode == 400) {
  //     PostRatingException(
  //         "You cannot rate a doctor you did not have an appointment with.");
  //   }
  // }

  Future<List<Rating>> getDoctorRatings(String doctorId) async {
    final String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw PostRatingException('Access token not available');
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userRole = prefs.getString('userRole');
    if (userRole == null) {
      throw GetDoctorRatingsException('User role not available');
    }

    final String endpoint =
        userRole.toLowerCase() == 'user' ? 'patient' : 'doctor';

    final Uri url = Uri.parse('$baseUrl/$endpoint/ratings/$doctorId');

    print(url.toString());
    final http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Rating> ratings =
          responseData.map((item) => Rating.fromJson(item)).toList();
      return ratings;
    } else {
      throw GetDoctorRatingsException('Failed to load doctor ratings');
    }
  }

  Future<void> deleteRating(String ratingId) async {
    final String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw DeleteRatingException('Access token not available');
    }

    final Uri url = Uri.parse('$baseUrl/patient/ratings/$ratingId');
    print(url.toString());
    final http.Response response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 200) {
      throw DeleteRatingException('Failed to delete rating');
    }
  }

  Future<void> editRating(Rating updatedRating) async {
    final String? accessToken = await _getAccessToken();
    if (accessToken == null) {
      throw EditRatingException('Access token not available');
    }

    final Uri url = Uri.parse('$baseUrl/patient/ratings/${updatedRating.id}');
    print(url.toString());
    final http.Response response = await http.patch(
      url,
      body: jsonEncode(updatedRating.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw EditRatingException('Failed to edit rating');
    }
  }
}
