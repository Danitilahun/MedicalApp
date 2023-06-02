import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tenaye/application/doctor/doctor_bloc.dart';
import 'package:tenaye/application/doctor/doctor_event.dart';
import 'package:tenaye/application/doctor/doctor_state.dart';
import 'package:tenaye/domain/doctor/doctor.dart';

class PutCertificatePage extends StatefulWidget {
  final Doctor doctor;

  PutCertificatePage({required this.doctor});

  @override
  _PutCertificatePageState createState() => _PutCertificatePageState();
}

class _PutCertificatePageState extends State<PutCertificatePage> {
  String? certificatePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Put Certificate'),
      ),
      body: Center(
        child: BlocProvider<DoctorProfileBloc>(
          create: (context) => DoctorProfileBloc(),
          child: BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
            builder: (context, state) {
              if (state is DoctorProfileCertificateUpdateInProgressState) {
                return CircularProgressIndicator();
              } else if (state is DoctorProfileFailureState) {
                return Text('Failed to update certificate: ${state.message}');
              } else if (state is DoctorProfileCertificateUpdateSuccessState) {
                // Show success message or navigate back
                return Text('Certificate updated successfully!');
              } else {
                // Render the UI for updating the certificate
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (certificatePath != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(certificatePath!)),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: false,
                        );

                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            certificatePath = result.files.single.path;
                          });
                        }
                      },
                      child: Text('Select Certificate'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (certificatePath != null) {
                          final event =
                              UpdateCertificateEvent(certificatePath!);
                          context.read<DoctorProfileBloc>().add(event);
                        }
                      },
                      child: Text('Update Certificate'),
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
