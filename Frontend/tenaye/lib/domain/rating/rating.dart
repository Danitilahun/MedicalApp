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
      id: json['_id'],
      doctorId: json['doctorId'],
      userId: json['userId'],
      message: json['message'],
      rating: json['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'userId': userId,
      'message': message,
      'rating': rating,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      id: map['id'],
      doctorId: map['doctorId'],
      userId: map['userId'],
      message: map['message'],
      rating: map['rating'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'userId': userId,
      'message': message,
      'rating': rating,
    };
  }
}
