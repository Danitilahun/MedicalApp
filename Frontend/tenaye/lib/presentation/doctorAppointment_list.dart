import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/appointment/appointment_bloc.dart';
import 'package:tenaye/application/appointment/appointment_event.dart';
import 'package:tenaye/application/appointment/appointment_state.dart';
import 'package:tenaye/domain/appointment/appointment.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/appointment/appointment_bloc.dart';
import 'package:tenaye/application/appointment/appointment_event.dart';
import 'package:tenaye/application/appointment/appointment_state.dart';
import 'package:tenaye/domain/appointment/appointment.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppointmentBloc>(context).add(GetAppointmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AppointmentSuccess) {
          return ListView.builder(
            itemCount: state.appointments.length,
            itemBuilder: (context, index) {
              final appointment = state.appointments[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reason: ${appointment.reason}'),
                    Text('Time: ${appointment.time}'),
                    Text('Date: ${appointment.date}'),
                  ],
                ),
                subtitle: appointment.reply != null &&
                        appointment.reply!.isNotEmpty
                    ? Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // Show alert dialog with the reply
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Replay'),
                                    content: Text(appointment.reply!),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Show Replay'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              // Show alert dialog with a text area for editing the reply
                              final TextEditingController replyController =
                                  TextEditingController(
                                      text: appointment.reply);
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit Replay'),
                                    content: TextField(
                                      controller: replyController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          final String reply =
                                              replyController.text;
                                          if (reply.isNotEmpty) {
                                            Navigator.of(context).pop();
                                            // Dispatch RescheduleAppointmentEvent with the updated appointment
                                            final updatedAppointment =
                                                Appointment(
                                              id: appointment.id,
                                              reason: appointment.reason,
                                              time: appointment.time,
                                              date: appointment.date,
                                              reply: reply,
                                            );
                                            BlocProvider.of<AppointmentBloc>(
                                                    context)
                                                .add(
                                              RescheduleAppointmentEvent(
                                                  updatedAppointment),
                                            );
                                            BlocProvider.of<AppointmentBloc>(
                                                    context)
                                                .add(GetAppointmentsEvent());
                                          }
                                        },
                                        child: Text('Save'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Edit Replay'),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          // Show alert dialog with a text area for entering the replay
                          final TextEditingController replyController =
                              TextEditingController();
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Enter Replay'),
                                content: TextField(
                                  controller: replyController,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      final String reply = replyController.text;
                                      if (reply.isNotEmpty) {
                                        Navigator.of(context).pop();
                                        // Dispatch RescheduleAppointmentEvent with the updated appointment
                                        final updatedAppointment = Appointment(
                                          id: appointment.id,
                                          reason: appointment.reason,
                                          time: appointment.time,
                                          date: appointment.date,
                                          reply: reply,
                                        );
                                        BlocProvider.of<AppointmentBloc>(
                                                context)
                                            .add(
                                          RescheduleAppointmentEvent(
                                              updatedAppointment),
                                        );

                                        BlocProvider.of<AppointmentBloc>(
                                                context)
                                            .add(GetAppointmentsEvent());
                                      }
                                    },
                                    child: Text('Send'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Replay'),
                      ),
              );
            },
          );
        } else if (state is AppointmentFailure) {
          return Center(
            child: Text('Failed to load appointments: ${state.errorMessage}'),
          );
        } else {
          return Center(
            child: Text('No appointments available.'),
          );
        }
      },
    );
  }
}
