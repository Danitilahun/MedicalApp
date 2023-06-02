class Appointment {
  final String? id;
  final String? userId;
  final String? doctorId;
  final String date; // Changed data type to String
  final String time;
  final String? reason;
  final String? message;
  final String? reply;

  Appointment({
    this.id,
    this.userId,
    this.doctorId,
    required this.date,
    required this.time,
    this.reason,
    this.message,
    this.reply,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'],
      userId: json['userId'],
      doctorId: json['doctorId'],
      date: json['bookDate'],
      time: json['bookTime'],
      reason: json['reason'],
      message: json['message'],
      reply: json['reply'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'date': date,
      'time': time.toString(),
      'reason': reason,
      'message': message,
      'reply': reply,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'date': date,
      'time': time,
      'reason': reason,
      'message': message,
      'reply': reply,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      userId: map['userId'],
      doctorId: map['doctorId'],
      date: map['date'],
      time: map['time'],
      reason: map['reason'],
      message: map['message'],
      reply: map['reply'],
    );
  }
}
