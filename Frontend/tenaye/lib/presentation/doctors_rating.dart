import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tenaye/application/rating/rating_bloc.dart';
import 'package:tenaye/application/rating/rating_event.dart';
import 'package:tenaye/application/rating/rating_state.dart';
import 'package:tenaye/domain/rating/rating.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  late String doctorId;
  @override
  void initState() {
    super.initState();
    retrieveDoctorId();
  }

  Future<void> retrieveDoctorId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorId = prefs.getString('userId') ?? '';
    });
    if (doctorId.isNotEmpty) {
      BlocProvider.of<RatingBloc>(context).add(GetDoctorRatingsEvent(doctorId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating Page'),
      ),
      body: BlocConsumer<RatingBloc, RatingState>(
        listener: (context, state) {
          // Handle any state changes here if needed
        },
        builder: (context, state) {
          if (state is RatingLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is RatingSuccess) {
            final List<Rating> ratings = state.ratings;
            return ListView.builder(
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                final Rating rating = ratings[index];
                return ListTile(
                  title: Text(rating.message),
                  subtitle: Text(rating.rating.toString()),
                  // Display other rating details as needed
                );
              },
            );
          } else if (state is RatingFailure) {
            return Center(
              child: Text('Failed to load ratings: ${state.error.message}'),
            );
          } else {
            return Center(
              child: Text('No ratings available.'),
            );
          }
        },
      ),
    );
  }
}
