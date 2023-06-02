import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/doctor/doctor_bloc.dart';
import 'package:tenaye/application/doctor/doctor_event.dart';
import 'package:tenaye/domain/doctor/doctor.dart';

class DoctorProfileEditPage extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfileEditPage({required this.doctor});

  @override
  _DoctorProfileEditPageState createState() => _DoctorProfileEditPageState();
}

class _DoctorProfileEditPageState extends State<DoctorProfileEditPage> {
  late Doctor _editedDoctor;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the edited doctor with the values from the passed doctor
    _editedDoctor = widget.doctor;

    // Set the initial values for the text fields
    _usernameController.text = _editedDoctor.username ?? '';
    _emailController.text = _editedDoctor.email ?? '';
    _specializationController.text = _editedDoctor.specialization ?? '';
    _phoneNumberController.text = _editedDoctor.phoneNumber ?? '';
    _feeController.text = _editedDoctor.feePerConsultation?.toString() ?? '';
    _cityController.text = _editedDoctor.city ?? '';
    _countryController.text = _editedDoctor.country ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _specializationController.dispose();
    _phoneNumberController.dispose();
    _feeController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _saveDoctorProfile() {
    if (_formKey.currentState!.validate()) {
      _editedDoctor = _editedDoctor.copyWith(
        username: _usernameController.text,
        email: _emailController.text,
        specialization: _specializationController.text,
        phoneNumber: _phoneNumberController.text,
        feePerConsultation: int.tryParse(_feeController.text),
        city: _cityController.text,
        country: _countryController.text,
      );

      final doctorProfileBloc = BlocProvider.of<DoctorProfileBloc>(context);
      doctorProfileBloc.add(UpdateProfileEvent(_editedDoctor));
      doctorProfileBloc.add(GetDoctorEvent());

      // Go back to the doctor profile page with the updated doctor object
      Navigator.pop(context, _editedDoctor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Doctor Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _specializationController,
                decoration: InputDecoration(labelText: 'Specialization'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a specialization';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _feeController,
                decoration: InputDecoration(labelText: 'Fee per Consultation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the fee per consultation';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a country';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _saveDoctorProfile,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
