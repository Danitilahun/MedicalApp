class Rating {
  final String? id; // New field: rating ID
  final String? doctorId;
  final String? userId;
  final String message;
  final double rating;

  Rating({
    this.id,
    this.doctorId,
    this.userId,
    required this.message,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'], // Assign the value of the 'id' key to the 'id' field
      doctorId: json['doctorId'],
      userId: json['userId'],
      message: json['message'],
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include the 'id' field in the JSON representation
      'doctorId': doctorId,
      'userId': userId,
      'message': message,
      'rating': rating,
    };
  }
}
