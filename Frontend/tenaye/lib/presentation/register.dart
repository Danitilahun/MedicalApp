import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/application/register/register_bloc.dart';
import 'package:tenaye/application/register/register_event.dart';
import 'package:tenaye/application/register/register_state.dart';
import 'package:tenaye/presentation/doctorDashboard.dart';
import 'package:tenaye/presentation/success.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _selectedTabIndex = 2;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = 2;
  }

  Future<String> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            child: Text(
              "Skip",
              style: TextStyle(color: Colors.black),
            ),
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
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton(0, 'user'),
                  SizedBox(width: 16.0),
                  _buildTabButton(1, 'doctor'),
                ],
              ),
            ),
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildRegistrationForm(context, isDoctor: false)
                  : _buildRegistrationForm(context, isDoctor: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String text) {
    final bool isSelected = _selectedTabIndex == index;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.blue : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () async {
        setState(() {
          _selectedTabIndex = index;
        });

        final preferences = await SharedPreferences.getInstance();
        await preferences.setString('role', text);
        print('Selected tab: $text'); // Print the selected tab value
      },
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context, {bool isDoctor = false}) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: BlocProvider(
          create: (_) => RegisterBloc(),
          child: RegisterForm(isDoctor: isDoctor),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  final bool isDoctor;

  const RegisterForm({Key? key, this.isDoctor = false}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterSuccess) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
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
        } else if (state is RegisterFailure) {
          // Registration failed, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.exception)),
          );
        }
      },
      builder: (context, state) {
        if (state is RegisterLoading) {
          // Show a loading indicator while registering
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/doctors.png',
              height: screenHeight * 0.3,
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showPassword,
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_showConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
              ),
              obscureText: !_showConfirmPassword,
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: screenWidth,
              child: ElevatedButton(
                child: Text('Register'),
                onPressed: () {
                  // Trigger the register event when the button is pressed
                  final username = _usernameController.text;
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  final confirmPassword = _confirmPasswordController.text;

                  context.read<RegisterBloc>().add(
                        RegisterSubmitted(
                          username: username,
                          email: email,
                          password: password,
                          confirmPassword: confirmPassword,
                        ),
                      );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextButton(
              child: Text('Already have an account? Log in'),
              onPressed: () {
                // Navigate to the login page
                Navigator.pushNamed(context, '/login');
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Registering as a ${widget.isDoctor ? 'Doctor' : 'User'}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tenaye/application/register/register_bloc.dart';
// import 'package:tenaye/application/register/register_event.dart';
// import 'package:tenaye/application/register/register_state.dart';
// import 'package:tenaye/presentation/doctorDashboard.dart';
// import 'package:tenaye/presentation/success.dart';

// class RegisterPage extends StatefulWidget {
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   int _selectedTabIndex = 0; // 0 for User, 1 for Doctor

//   Future<String> getUserRole() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userRole') ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Register',
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           TextButton(
//             child: Text(
//               "Skip",
//               style: TextStyle(color: Colors.black),
//             ),
//             onPressed: () async {
//               final String userRole = await getUserRole();
//               if (userRole == 'doctor') {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DoctorDashboard()),
//                 );
//               } else {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SuccessPage()),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildTabButton(0, 'user'),
//                   SizedBox(width: 16.0),
//                   _buildTabButton(1, 'doctor'),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: _selectedTabIndex == 0
//                   ? _buildRegistrationForm(context, isDoctor: false)
//                   : _buildRegistrationForm(context, isDoctor: true),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTabButton(int index, String text) {
//     final bool isSelected = _selectedTabIndex == index;
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: isSelected ? Colors.blue : Colors.grey,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//       ),
//       onPressed: () async {
//         setState(() {
//           _selectedTabIndex = index;
//         });

//         final preferences = await SharedPreferences.getInstance();
//         await preferences.setString('role', text);
//         print('Selected tab: $text'); // Print the selected tab value
//       },
//       child: Text(
//         text,
//         style: TextStyle(
//           color: isSelected ? Colors.white : Colors.black,
//         ),
//       ),
//     );
//   }

//   Widget _buildRegistrationForm(BuildContext context, {bool isDoctor = false}) {
//     return SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.all(20.0),
//         child: BlocProvider(
//           create: (_) => RegisterBloc(),
//           child: RegisterForm(isDoctor: isDoctor),
//         ),
//       ),
//     );
//   }
// }

// class RegisterForm extends StatefulWidget {
//   final bool isDoctor;

//   const RegisterForm({Key? key, this.isDoctor = false}) : super(key: key);

//   @override
//   _RegisterFormState createState() => _RegisterFormState();
// }

// class _RegisterFormState extends State<RegisterForm> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool _showPassword = false;
//   bool _showConfirmPassword = false;

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final double screenWidth = mediaQuery.size.width;
//     final double screenHeight = mediaQuery.size.height;

//     return BlocConsumer<RegisterBloc, RegisterState>(
//       listener: (context, state) {
//         if (state is RegisterSuccess) {
//           // Registration successful, navigate to another page
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => SuccessPage()),
//           );
//         } else if (state is RegisterFailure) {
//           // Registration failed, show an error message
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.exception)),
//           );
//         }
//       },
//       builder: (context, state) {
//         if (state is RegisterLoading) {
//           // Show a loading indicator while registering
//           return Center(child: CircularProgressIndicator());
//         }
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/doctors.png',
//               height: screenHeight * 0.3,
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.text,
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                       _showPassword ? Icons.visibility : Icons.visibility_off),
//                   onPressed: () {
//                     setState(() {
//                       _showPassword = !_showPassword;
//                     });
//                   },
//                 ),
//               ),
//               obscureText: !_showPassword,
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             TextField(
//               controller: _confirmPasswordController,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(_showConfirmPassword
//                       ? Icons.visibility
//                       : Icons.visibility_off),
//                   onPressed: () {
//                     setState(() {
//                       _showConfirmPassword = !_showConfirmPassword;
//                     });
//                   },
//                 ),
//               ),
//               obscureText: !_showConfirmPassword,
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             SizedBox(
//               width: screenWidth,
//               child: ElevatedButton(
//                 child: Text('Register'),
//                 onPressed: () {
//                   // Trigger the register event when the button is pressed
//                   final username = _usernameController.text;
//                   final email = _emailController.text;
//                   final password = _passwordController.text;
//                   final confirmPassword = _confirmPasswordController.text;

//                   context.read<RegisterBloc>().add(
//                         RegisterSubmitted(
//                           username: username,
//                           email: email,
//                           password: password,
//                           confirmPassword: confirmPassword,
//                         ),
//                       );
//                 },
//               ),
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             TextButton(
//               child: Text('Already have an account? Log in'),
//               onPressed: () {
//                 // Navigate to the login page
//                 Navigator.pushNamed(context, '/login');
//               },
//             ),
//             SizedBox(height: screenHeight * 0.02),
//             Text(
//               'Registering as a ${widget.isDoctor ? 'Doctor' : 'User'}',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
