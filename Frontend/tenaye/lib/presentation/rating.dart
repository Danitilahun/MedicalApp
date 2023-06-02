import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/application/rating/rating_bloc.dart';
import 'package:tenaye/application/rating/rating_event.dart';
import 'package:tenaye/application/rating/rating_state.dart';
import 'package:tenaye/domain/doctor/doctor.dart';
import 'package:tenaye/domain/rating/rating.dart';

class RatingScreen extends StatefulWidget {
  final Doctor doctor;

  RatingScreen({required this.doctor});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  double _rating = 0.0;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate ${widget.doctor.username}'),
      ),
      body: BlocConsumer<RatingBloc, RatingState>(
        listener: (context, state) {
          if (state is RatingSuccess) {
            // Rating successfully posted, perform any necessary actions
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Rating Successful'),
                content:
                    Text('Thank you for rating ${widget.doctor.username}!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate back to the previous screen
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is RatingFailure) {
            // Rating failed, display an error message
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Rating Failed'),
                content: Text(state.error.message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  'Rate ${widget.doctor.username}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Email: ${widget.doctor.email}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 40),
                    SizedBox(width: 16),
                    Text(
                      '$_rating',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: _rating,
                  min: 0,
                  max: 5,
                  divisions: 5,
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(labelText: 'Message'),
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Create the Rating object with the selected values
                      final userId = await getUserID();
                      final rating = Rating(
                        userId: userId,
                        doctorId: widget.doctor.id,
                        rating: _rating,
                        message: _messageController.text,
                      );

                      // Submit the rating event
                      context.read<RatingBloc>().add(PostRatingEvent(rating));
                    }
                  },
                  child: Text('Submit Rating'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    return userId;
  }
}
