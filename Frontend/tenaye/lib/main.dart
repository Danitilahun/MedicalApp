import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/Infrastructure/local/tenayeDB.dart';
import 'package:tenaye/application/appointment/appointment_bloc.dart';
import 'package:tenaye/application/auth/auth_bloc.dart';
import 'package:tenaye/application/doctor/doctor_bloc.dart';
import 'package:tenaye/application/doctor_list/doctor_list_bloc.dart';
import 'package:tenaye/application/login/login_bloc.dart';
import 'package:tenaye/application/rating/rating_bloc.dart';
import 'package:tenaye/application/register/register_bloc.dart';
import 'package:tenaye/application/user/user_bloc.dart';
import 'package:tenaye/domain/user/user.dart';
import 'package:tenaye/presentation/doctorDashboard.dart';
import 'package:tenaye/presentation/landingPage.dart';
import 'package:tenaye/presentation/login.dart';
import 'package:tenaye/presentation/register.dart';
import 'package:tenaye/presentation/success.dart';

void main() {
  runApp(MyApp());
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
}

class MyApp extends StatelessWidget {
  Future<SharedPreferences> _initializeSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _initializeSharedPreferences(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final sharedPreferences = snapshot.data;

          sharedPreferences!.getKeys().forEach((key) {
            final value = sharedPreferences.get(key);
            print('SharedPreferences: $key = $value');
          });

          // Check if the user is already logged in
          final bool isLoggedIn = sharedPreferences!.containsKey('accessToken');
          final String userRole = sharedPreferences.getString('userRole') ?? '';

          return MultiProvider(
            providers: [
              BlocProvider<RegisterBloc>(
                create: (context) => RegisterBloc(),
              ),
              BlocProvider<DoctorProfileBloc>(
                create: (context) => DoctorProfileBloc(),
              ),
              BlocProvider<AppointmentBloc>(
                create: (context) => AppointmentBloc(),
              ),
              BlocProvider<RatingBloc>(
                create: (context) => RatingBloc(),
              ),
              BlocProvider<DoctorBloc>(
                create: (context) => DoctorBloc(),
              ),
              BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc(),
              ),
              BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(),
              ),
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'My App',
              initialRoute: isLoggedIn
                  ? '/dashboard'
                  : '/', // Redirect to dashboard or login page
              routes: {
                '/dashboard': (context) {
                  if (userRole == 'doctor') {
                    return DoctorDashboard();
                  } else {
                    return SuccessPage();
                  }
                },
                '/login': (context) => LoginPage(),
                '/': (context) => LandingPage(),
              },
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error
          return Text('Error initializing SharedPreferences');
        } else {
          // Display loading indicator
          return CircularProgressIndicator();
        }
      },
    );
  }
}
