import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenaye/application/rating/rating_bloc.dart';
import 'package:tenaye/application/rating/rating_event.dart';
import 'package:tenaye/application/rating/rating_state.dart';
import 'package:tenaye/domain/rating/rating.dart';

class RatingListPage extends StatefulWidget {
  final String doctorId;

  RatingListPage({required this.doctorId});

  @override
  _RatingListPageState createState() => _RatingListPageState();
}

class _RatingListPageState extends State<RatingListPage> {
  late RatingBloc _ratingBloc;
  String? userId;

  @override
  void initState() {
    super.initState();
    _ratingBloc = BlocProvider.of<RatingBloc>(context);
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      _loadUserId().then((_) {
        _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Ratings'),
      ),
      body: BlocListener<RatingBloc, RatingState>(
        listener: (context, state) {
          if (state is EditRatingEvent) {
            _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
          }
          if (state is DeleteRatingEvent) {
            _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
          }
        },
        child: BlocBuilder<RatingBloc, RatingState>(
          builder: (context, state) {
            if (state is RatingLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RatingSuccess) {
              final ratings = state.ratings;
              return ListView.builder(
                itemCount: ratings.length,
                itemBuilder: (context, index) {
                  final rating = ratings[index];
                  final bool isEditable = rating.userId == userId;
                  return ListTile(
                    title: Text('Rating: ${rating.rating}'),
                    subtitle: Text('Message: ${rating.message}'),
                    // Add more rating details as needed
                    trailing: isEditable
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Handle edit button press
                                  _editRating(context, rating);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Handle delete button press
                                  _confirmDeleteRating(context, rating.id!);
                                },
                              ),
                            ],
                          )
                        : null,
                  );
                },
              );
            } else if (state is RatingFailure) {
              return Center(child: Text('Failed to fetch ratings'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void _editRating(BuildContext context, Rating rating) {
    showDialog(
      context: context,
      builder: (context) {
        // Controller for the rating input
        final TextEditingController ratingController = TextEditingController();
        ratingController.text = rating.rating.toString();

        // Controller for the message input
        final TextEditingController messageController = TextEditingController();
        messageController.text = rating.message;

        return AlertDialog(
          title: Text('Edit Rating'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ratingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Rating'),
              ),
              TextField(
                controller: messageController,
                decoration: InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
                Navigator.pop(context);
                _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedRating = Rating(
                  id: rating.id,
                  rating: double.parse(ratingController.text),
                  message: messageController.text,
                );
                _ratingBloc.add(EditRatingEvent(updatedRating));
                _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
                Navigator.pop(context);
                _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteRating(BuildContext context, String ratingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Rating'),
          content: Text('Are you sure you want to delete this rating?'),
          actions: [
            TextButton(
              onPressed: () {
                _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _ratingBloc.add(DeleteRatingEvent(ratingId));
                _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
                Navigator.pop(context);
                _ratingBloc.add(GetDoctorRatingsEvent(widget.doctorId));
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
