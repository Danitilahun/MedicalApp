import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/auth/auth_bloc.dart';
import 'package:tenaye/application/auth/auth_event.dart';
import 'package:tenaye/application/auth/auth_state.dart';
import 'package:tenaye/application/doctor/doctor_bloc.dart';
import 'package:tenaye/application/doctor/doctor_event.dart';
import 'package:tenaye/application/doctor/doctor_state.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/presentation/doctor_profile_edit.dart';
import 'package:tenaye/presentation/doctor_text_edit.dart';
import 'package:tenaye/presentation/putcirtificatepage.dart';

class DoctorProfilePage extends StatefulWidget {
  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final doctorProfileBloc = DoctorProfileBloc();
  final authBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    doctorProfileBloc.add(GetDoctorEvent());
  }

  @override
  void dispose() {
    doctorProfileBloc.close();
    authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
      ),
      body: BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
        bloc: doctorProfileBloc,
        builder: (context, state) {
          if (state is DoctorProfileLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DoctorProfileLoadedState) {
            return _buildDoctorProfile(state.doctor);
          } else if (state is DoctorProfileErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          authBloc.add(LogOut());
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        },
        child: Icon(Icons.logout),
      ),
    );
  }

  Widget _buildDoctorProfile(Doctor doctor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${doctor.username ?? ''}'),
                Text('Email: ${doctor.email ?? ''}'),
                Text('Specialization: ${doctor.specialization ?? ''}'),
                Text('Phone Number: ${doctor.phoneNumber ?? ''}'),
                Text(
                    'Fee per Consultation: ${doctor.feePerConsultation ?? ''}'),
                Text('Certificate Status: ${doctor.certificateStatus ?? ''}'),
                Text('City: ${doctor.city ?? ''}'),
                Text('Country: ${doctor.country ?? ''}'),
                Text(
                    'Number of Ratings: ${doctor.numberOfPeopleRateThisDoctor}'),
                Text('Total Rating: ${doctor.sumOfRating}'),
                Text('Average Rating: ${doctor.rating}'),
                // Add more fields as needed
              ],
            ),
          ),
          _buildProfileImage(doctor),
          _buildCertificateImage(doctor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DoctorProfileEditPage(doctor: doctor),
                    ),
                  );
                },
                child: Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement delete functionality
                },
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(Doctor? doctor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipOval(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileImagePage(
                    doctor: doctor!,
                  ),
                ),
              );
            },
            child: Container(
              child: doctor?.profileImage != null &&
                      doctor!.profileImage!.isNotEmpty
                  ? Image.network(
                      'http://10.0.2.2:3000/images/${doctor.profileImage!}',
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.grey,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateImage(Doctor? doctor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PutCertificatePage(
                    doctor: doctor!,
                  ),
                ),
              );
            },
            child: Container(
              child:
                  doctor!.certificate != null && doctor.certificate!.isNotEmpty
                      ? Image.network(
                          'http://10.0.2.2:3000/certificates/${doctor.certificate!}',
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/doctors.png', // Replace with your placeholder image asset path
                          fit: BoxFit.cover,
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
