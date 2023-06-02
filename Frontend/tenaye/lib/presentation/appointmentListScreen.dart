import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/application/appointment/appointment_bloc.dart';
import 'package:tenaye/application/appointment/appointment_event.dart';
import 'package:tenaye/application/appointment/appointment_state.dart';
import 'package:tenaye/domain/appointment/appointment.dart';

class AppointmentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appointmentBloc = BlocProvider.of<AppointmentBloc>(context);

    appointmentBloc.add(GetAppointmentsEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text('My Appointments'),
      ),
      body: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AppointmentSuccess) {
            final appointments = state.appointments;

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  title: Text(appointment.date),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.time),
                      Text('Message: ${appointment.message}'),
                      Text('Reason: ${appointment.reason}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showRescheduleDialog(context, appointment);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _confirmCancellation(context, appointment.id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.reply),
                        onPressed: () {
                          _showReplyDialog(context, appointment);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is AppointmentFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          return Container();
        },
      ),
    );
  }

  void _showRescheduleDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reschedule Appointment'),
          content: Text('Do you want to reschedule this appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showRescheduleForm(context, appointment);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showRescheduleForm(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) {
        String selectedDate = appointment.date;
        ValueNotifier<String> selectedTime =
            ValueNotifier(appointment.time.toString());
        String? message = appointment.message;
        String? reason = appointment.reason;

        return AlertDialog(
          title: Text('Reschedule Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selected Date: ${selectedDate.toString()}'),
              SizedBox(height: 10),
              ValueListenableBuilder<String>(
                valueListenable: selectedTime,
                builder: (context, value, child) {
                  return DropdownButton<String>(
                    value: value,
                    onChanged: (String? newValue) {
                      selectedTime.value = newValue!;
                    },
                    items: <String>['Morning', 'Afternoon', 'Evening']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Message',
                ),
                onChanged: (value) {
                  message = value;
                },
                controller: TextEditingController(text: message),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Reason',
                ),
                onChanged: (value) {
                  reason = value;
                },
                controller: TextEditingController(text: reason),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Dispatch the reschedule event to the bloc
                final updatedAppointment = Appointment(
                  id: appointment.id,
                  date: selectedDate,
                  time: selectedTime.value,
                  message: message,
                  reason: reason,
                );
                BlocProvider.of<AppointmentBloc>(context).add(
                  RescheduleAppointmentEvent(updatedAppointment),
                );
                Navigator.pop(context);
                BlocProvider.of<AppointmentBloc>(context)
                    .add(GetAppointmentsEvent());
              },
              child: Text('Reschedule'),
            ),
          ],
        );
      },
    );
  }

  void _confirmCancellation(BuildContext context, String? appointmentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: Text('Are you sure you want to cancel this appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Dispatch the cancellation event to the bloc
                BlocProvider.of<AppointmentBloc>(context).add(
                  CancelAppointmentEvent(appointmentId!),
                );
                // BlocProvider.of<AppointmentBloc>(context).add(
                //   GetAppointmentsEvent()
                // );
                Navigator.pop(context);
                _showDeleteSuccessDialog(context); // Show delete success dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Successful'),
          content: Text('The appointment has been successfully deleted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<AppointmentBloc>(context)
                    .add(GetAppointmentsEvent());
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showReplyDialog(BuildContext context, Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Appointment Reply'),
          content: appointment.reply != null && appointment.reply!.isNotEmpty
              ? Text(appointment.reply!)
              : Text('No reply available.'),
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
}
