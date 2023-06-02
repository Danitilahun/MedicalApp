import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/application/appointment/appointment_bloc.dart';
import 'package:tenaye/application/appointment/appointment_event.dart';
import 'package:tenaye/application/appointment/appointment_state.dart';
import 'package:tenaye/domain/appointment/appointment.dart';
import 'package:tenaye/domain/doctor/doctor.dart';

class AppointmentScreen extends StatefulWidget {
  final Doctor doctor;

  AppointmentScreen({required this.doctor});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = 'Morning';
  String reason = '';
  String message = '';

  List<DateTime> availableDates = [];

  @override
  void initState() {
    super.initState();
    // Set the available dates (3 days as an example)
    final now = DateTime.now();
    availableDates = [
      now,
      now.add(Duration(days: 1)),
      now.add(Duration(days: 2)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Appointment'),
      ),
      body: BlocConsumer<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentCreated) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Appointment Created'),
                  content:
                      Text('Your appointment has been successfully created.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else if (state is AppointmentFailure) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(state.errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Selected Date:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Select Time:',
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton<String>(
                  value: selectedTime,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTime = newValue!;
                    });
                  },
                  items: <String>['Morning', 'Afternoon', 'Evening']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Reason',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      reason = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      message = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final userId = await getUserID();
                    final appointment = Appointment(
                      userId: userId,
                      doctorId: widget.doctor.id,
                      date:
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      time: selectedTime,
                      reason: reason,
                      message: message,
                    );
                    BlocProvider.of<AppointmentBloc>(context).add(
                      BookAppointmentEvent(appointment),
                    );
                  },
                  child: Text('Create Appointment'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showDatePicker();
                  },
                  child: Text('Select Date'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      selectableDayPredicate: (DateTime date) {
        // Get the date without the time
        final selectedDateWithoutTime =
            DateTime(date.year, date.month, date.day);

        // Check if the selected date is in the availableDates list
        return availableDates.any((availableDate) =>
            DateTime(
                availableDate.year, availableDate.month, availableDate.day) ==
            selectedDateWithoutTime);
      },
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
        });
      }
    });
  }

  Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    return userId;
  }
}
