// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tenaye/application/user/user_bloc.dart';
// import 'package:tenaye/application/user/user_state.dart';
// import 'package:tenaye/application/user/user_event.dart';
// import 'package:tenaye/presentation/appointmentListScreen.dart';
// import 'package:tenaye/presentation/doctorListPage.dart';
// import 'package:tenaye/presentation/doctorProfile.dart';
// import 'package:tenaye/presentation/home_widget.dart';
// import 'package:tenaye/presentation/profile.dart';

// class SuccessPage extends StatefulWidget {
//   @override
//   _SuccessPageState createState() => _SuccessPageState();
// }

// class _SuccessPageState extends State<SuccessPage> {
//   int _currentIndex = 0;

//   void _navigateToDoctorList(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => DoctorsListPage()),
//     );
//   }

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<ProfileBloc>(context).add(GetUserEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentIndex == 0
//           ? _buildCurrentContent()
//           : _currentIndex == 1
//               ? AppointmentListScreen()
//               : ProfilePage(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.check),
//             label: 'Current Content',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Appointments',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCurrentContent() {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Registration Successful!'),
//               SizedBox(height: 16),
//               TextButton(
//                 onPressed: () => _navigateToDoctorList(context),
//                 child: Text('View All'),
//               ),
//               SizedBox(height: 32),
//               BlocBuilder<ProfileBloc, ProfileState>(
//                 builder: (context, state) {
//                   if (state is ProfileLoadedState) {
//                     final user = state.user;
//                     final name = user.username ?? 'Guest';
//                     final imageUrl = 'assets/avator.jpg';

//                     return Column(
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: user.image.isNotEmpty
//                               ? NetworkImage(
//                                   'http://10.0.2.2:3000/images/${user.image}')
//                               : AssetImage('assets/avator.jpg')
//                                   as ImageProvider<Object>,
//                           radius: 50,
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Welcome, $name!',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     );
//                   } else {
//                     return CircularProgressIndicator();
//                   }
//                 },
//               ),
//               PopularDoctors()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tenaye/application/user/user_bloc.dart';
// import 'package:tenaye/application/user/user_state.dart';
// import 'package:tenaye/application/user/user_event.dart';
// import 'package:tenaye/presentation/appointmentListScreen.dart';
// import 'package:tenaye/presentation/doctorListPage.dart';
// import 'package:tenaye/presentation/doctorProfile.dart';
// import 'package:tenaye/presentation/home_widget.dart';
// import 'package:tenaye/presentation/profile.dart';

// class SuccessPage extends StatefulWidget {
//   @override
//   _SuccessPageState createState() => _SuccessPageState();
// }

// class _SuccessPageState extends State<SuccessPage> {
//   int _currentIndex = 0;

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<ProfileBloc>(context).add(GetUserEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentIndex == 0
//           ? _buildCurrentContent()
//           : _currentIndex == 1
//               ? AppointmentListScreen()
//               : ProfilePage(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.check),
//             label: 'Current Content',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Appointments',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCurrentContent() {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => DoctorsListPage()),
//                   );
//                 },
//                 child: Text('View All'),
//               ),
//               SizedBox(height: 32),
//               BlocBuilder<ProfileBloc, ProfileState>(
//                 builder: (context, state) {
//                   if (state is ProfileLoadedState) {
//                     final user = state.user;
//                     final name = user.username ?? 'Guest';
//                     final imageUrl = 'assets/avator.jpg';

//                     return Column(
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: user.image.isNotEmpty
//                               ? NetworkImage(
//                                   'http://10.0.2.2:3000/images/${user.image}')
//                               : AssetImage('assets/avator.jpg')
//                                   as ImageProvider<Object>,
//                           radius: 50,
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Welcome, $name!',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     );
//                   } else {
//                     return CircularProgressIndicator();
//                   }
//                 },
//               ),
//               DoctorsGrid(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DoctorsGrid extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       crossAxisCount: 2,
//       padding: EdgeInsets.all(16),
//       childAspectRatio: MediaQuery.of(context).size.width /
//           (MediaQuery.of(context).size.height / 4),
//       children: List.generate(4, (index) {
//         return GestureDetector(
//           onTap: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => ,
//             //   ),
//             // );
//           },
//           child: Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Container(
//               alignment: Alignment.center,
//               child: Text('Doctor $index'),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/doctor_list/doctor_list_bloc.dart';
import 'package:tenaye/application/doctor_list/doctor_list_event.dart';
import 'package:tenaye/application/doctor_list/doctor_list_state.dart';
import 'package:tenaye/application/user/user_bloc.dart';
import 'package:tenaye/application/user/user_state.dart';
import 'package:tenaye/application/user/user_event.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/presentation/appointmentListScreen.dart';
import 'package:tenaye/presentation/doctorDetail.dart';
import 'package:tenaye/presentation/doctorListPage.dart';
import 'package:tenaye/presentation/doctorProfile.dart';
import 'package:tenaye/presentation/profile.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetUserEvent());
    BlocProvider.of<DoctorBloc>(context).add(FetchDoctors());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? _buildCurrentContent()
          : _currentIndex == 1
              ? AppointmentListScreen()
              : ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Current Content',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorsListPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Popular Doctors'),
                    Text('View All'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is DoctorsLoaded) {
                  final doctors = state.doctors;
                  return DoctorsGrid(doctors: doctors);
                } else if (state is DoctorsLoadFailure) {
                  return Text('Failed to load doctors');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorsGrid extends StatelessWidget {
  final List<Doctor> doctors;

  const DoctorsGrid({required this.doctors});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: EdgeInsets.all(16),
      childAspectRatio: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height / 2),
      children: doctors.map((doctor) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorDetailsPage(doctor: doctor),
              ),
            );
          },
          child: Card(
            color: Colors.grey[300],
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundImage: doctor.profileImage != null
                          ? NetworkImage(
                              'http://10.0.2.2:3000/images/${doctor.profileImage}')
                          : AssetImage('assets/avator.jpg')
                              as ImageProvider<Object>,
                      radius: 40,
                    ),
                  ),
                  Text(doctor.username!),
                  SizedBox(height: 8),
                  Text(
                    'Rating : ${double.parse(doctor.rating.toStringAsFixed(1))}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
