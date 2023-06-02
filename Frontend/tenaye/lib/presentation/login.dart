import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/application/login/login_bloc.dart';
import 'package:tenaye/application/login/login_event.dart';
import 'package:tenaye/application/login/login_state.dart';
import 'package:tenaye/presentation/doctorDashboard.dart';
import 'package:tenaye/presentation/register.dart';
import 'package:tenaye/presentation/success.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _submitLoginForm(BuildContext context) {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    BlocProvider.of<LoginBloc>(context)
        .add(LoginSubmitted(email: email, password: password));
  }

  Future<String> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingVertical = screenHeight * 0.04;
    final double paddingHorizontal = screenWidth * 0.05;
    final double imageHeight = screenHeight * 0.2;
    final double textFieldHeight = screenHeight * 0.08;
    final double buttonHeight = screenHeight * 0.08;
    final double fontSize = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          TextButton(
            onPressed: () async {
              final String userRole = await getUserRole();
              if (userRole == 'doctor') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorDashboard()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuccessPage()),
                );
              }
            },
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            // Login successful, navigate to the success page
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            final String userRole = prefs.getString('userRole') ?? '';
            // Registration successful, navigate to another page
            if (userRole == 'doctor') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorDashboard()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SuccessPage()),
              );
            }
          } else if (state is LoginFailure) {
            // Login failed, show an error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.exception)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: paddingVertical,
                  horizontal: paddingHorizontal,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: paddingVertical),
                    Image.asset(
                      "assets/doctors.png",
                      height: imageHeight,
                    ),
                    SizedBox(height: paddingVertical),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: paddingVertical),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: paddingVertical),
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => _submitLoginForm(context),
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: paddingVertical),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to the RegisterPage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
