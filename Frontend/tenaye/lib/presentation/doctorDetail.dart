import 'package:flutter/material.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/presentation/bookAppointment.dart';
import 'package:tenaye/presentation/rating.dart';
import 'package:tenaye/presentation/rating_list.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Doctor Profile Image
            Center(
              child: CircleAvatar(
                backgroundImage: doctor.profileImage != null
                    ? NetworkImage(
                        'http://10.0.2.2:3000/images/${doctor.profileImage}')
                    : AssetImage('assets/avator.jpg') as ImageProvider<Object>,
                radius: 100,
              ),
            ),
            SizedBox(height: 16.0),
            // Doctor Username
            Text(
              'Username: ${doctor.username}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              '${doctor.numberOfPeopleRateThisDoctor.toString()} people rate ${doctor.username}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Rating : ${double.parse(doctor.rating.toStringAsFixed(1))}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            // Doctor Specialty
            Text(
              'Specialty: ${doctor.specialization}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            // Add more doctor information here
            // For example:
            Text(
              'Email: ${doctor.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Phone Number: ${doctor.phoneNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Fee per Consultation: ${doctor.feePerConsultation}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Certificate Status: ${doctor.certificateStatus}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'City: ${doctor.city}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Country: ${doctor.country}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Experience: ${doctor.experience}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            // View Ratings Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingListPage(doctorId: doctor.id!),
                  ),
                );
              },
              child: Text('View Ratings'),
            ),
            SizedBox(height: 8.0),
            // Rate Me Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingScreen(doctor: doctor),
                  ),
                );
              },
              child: Text('Rate Me'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentScreen(doctor: doctor),
            ),
          );
        },
        child: Icon(Icons.calendar_today),
      ),
    );
  }
}
