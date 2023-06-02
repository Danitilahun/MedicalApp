import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/auth/auth_bloc.dart';
import 'package:tenaye/application/auth/auth_event.dart';
import 'package:tenaye/application/user/user_bloc.dart';
import 'package:tenaye/application/user/user_event.dart';
import 'package:tenaye/application/user/user_state.dart';
import 'package:tenaye/domain/user/user.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = context.read<ProfileBloc>();
    _profileBloc
        .add(GetUserEvent()); // Dispatch GetUSerEvent to fetch user profile
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _logout(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(LogOut());
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileLoadedState) {
            final user = state.user;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Image
                  CircleAvatar(
                    backgroundImage: user.image.isNotEmpty
                        ? NetworkImage(
                            'http://10.0.2.2:3000/images/${user.image}')
                        : AssetImage('assets/avator.jpg')
                            as ImageProvider<Object>,
                    radius: 80,
                  ),
                  SizedBox(height: 32.0),
                  // Email
                  Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  // Location
                  Text(
                    'Location:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.location,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  // Username
                  Text(
                    'Username:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.username,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 32.0),
                  // Update Profile Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to UpdateProfilePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateProfilePage(user: user),
                        ),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                  SizedBox(height: 16.0),
                  // Delete Account Button
                  ElevatedButton(
                    onPressed: () {
                      // Show a confirmation dialog
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Delete Account'),
                          content: Text(
                              'Are you sure you want to delete your account?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Dispatch the DeleteAccountEvent
                                _profileBloc.add(DeleteAccountEvent());
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Delete Account'),
                  ),
                ],
              ),
            );
          } else if (state is ProfileErrorState) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else if (state is ProfileDeletedState) {
            return Center(
              child: Text('Account Deleted'),
            );
          } else {
            return Center(
              child: Text('Unknown State'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _logout(context),
        icon: Icon(Icons.logout),
        label: Text('Logout'),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class UpdateProfilePage extends StatefulWidget {
  final User user;

  UpdateProfilePage({required this.user});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  late TextEditingController _usernameController;
  late String? _filePath;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _locationController = TextEditingController(text: widget.user.location);
    _usernameController = TextEditingController(text: widget.user.username);
    _filePath = widget.user.image;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _locationController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Image Field
            GestureDetector(
              onTap: () {
                _pickFile();
              },
              child: CircleAvatar(
                backgroundImage:
                    _filePath != null ? FileImage(File(_filePath!)) : null,
                radius: 100,
              ),
            ),
            SizedBox(height: 32.0),
            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Location Field
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // Username Field
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32.0),
            // Update Button
            ElevatedButton(
              onPressed: () {
                // Create a new User object with updated values
                final updatedUser = User(
                  id: widget.user.id,
                  email: _emailController.text,
                  location: _locationController.text,
                  username: _usernameController.text,
                );

                final imagePath = _filePath ?? widget.user.image;
                // Dispatch the UpdateProfileEvent
                context
                    .read<ProfileBloc>()
                    .add(UpdateProfileEvent(updatedUser));
                // context.read<ProfileBloc>().add(GetUserEvent());

                context
                    .read<ProfileBloc>()
                    .add(UpdateProfileImageEvent(imagePath));

                // Navigate back to the ProfilePage
                Navigator.pop(context);
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
