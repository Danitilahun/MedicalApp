import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tenaye/application/doctor/doctor_bloc.dart';
import 'package:tenaye/application/doctor/doctor_event.dart';
import 'package:tenaye/application/doctor/doctor_state.dart';
import 'package:tenaye/domain/doctor/doctor.dart';

class EditProfileImagePage extends StatefulWidget {
  final Doctor doctor;

  EditProfileImagePage({required this.doctor});

  @override
  _EditProfileImagePageState createState() => _EditProfileImagePageState();
}

class _EditProfileImagePageState extends State<EditProfileImagePage> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Image'),
      ),
      body: Center(
        child: BlocProvider<DoctorProfileBloc>(
          create: (context) => DoctorProfileBloc(),
          child: BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
            builder: (context, state) {
              if (state is DoctorProfileImageUpdateInProgressState) {
                return CircularProgressIndicator();
              } else if (state is DoctorProfileFailureState) {
                return Text('Failed to update profile image: ${state.message}');
              } else if (state is DoctorProfileImageUpdateSuccessState) {
                // Show success message or navigate back
                return Text('Profile image updated successfully!');
              } else {
                // Render the UI for editing the profile image
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (imagePath != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(imagePath!)),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowCompression: true,
                        );

                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            imagePath = result.files.single.path;
                          });
                        }
                      },
                      child: Text('Select Image'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (imagePath != null) {
                          final event = UpdateProfileImageEvent(imagePath!);
                          context.read<DoctorProfileBloc>().add(event);
                        }
                      },
                      child: Text('Update Image'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
