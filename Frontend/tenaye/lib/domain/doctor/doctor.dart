class Doctor {
  final String? id;
  final String? username;
  final String? email;
  final String? profileImage;
  final String? phoneNumber;
  final String? specialization;
  final int? feePerConsultation;
  final String? certificate;
  final String? certificateStatus;
  final String? city;
  final String? country;
  final String? experience;
  final int numberOfPeopleRateThisDoctor;
  final int sumOfRating;
  final dynamic rating;

  Doctor({
    this.id,
    this.username,
    this.email,
    this.profileImage,
    this.phoneNumber,
    this.specialization,
    this.feePerConsultation,
    this.certificate,
    this.certificateStatus,
    this.city,
    this.country,
    this.experience,
    this.numberOfPeopleRateThisDoctor = 0,
    this.sumOfRating = 0,
    this.rating,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json');
    return Doctor(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profileImage'],
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'],
      feePerConsultation: json['feePerConsultation'],
      certificate: json['certificate'],
      certificateStatus: json['certificateStatus'],
      city: json['city'],
      country: json['country'],
      experience: json['experience'],
      numberOfPeopleRateThisDoctor: json['numberOfPeopleRateThisDoctor'],
      sumOfRating: json['sumOfRating'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'feePerConsultation': feePerConsultation,
      'certificate': certificate,
      'certificateStatus': certificateStatus,
      'city': city,
      'country': country,
      'experience': experience,
      'numberOfPeopleRateThisDoctor': numberOfPeopleRateThisDoctor,
      'sumOfRating': sumOfRating,
      'rating': rating,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'feePerConsultation': feePerConsultation,
      'certificate': certificate,
      'certificateStatus': certificateStatus,
      'city': city,
      'country': country,
      'experience': experience,
      'numberOfPeopleRateThisDoctor': numberOfPeopleRateThisDoctor,
      'sumOfRating': sumOfRating,
      'rating': rating,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      profileImage: map['profileImage'],
      phoneNumber: map['phoneNumber'],
      specialization: map['specialization'],
      feePerConsultation: map['feePerConsultation'],
      certificate: map['certificate'],
      certificateStatus: map['certificateStatus'],
      city: map['city'],
      country: map['country'],
      experience: map['experience'],
      numberOfPeopleRateThisDoctor: map['numberOfPeopleRateThisDoctor'],
      sumOfRating: map['sumOfRating'],
      rating: map['rating'],
    );
  }

  Doctor copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImage,
    String? phoneNumber,
    String? specialization,
    int? feePerConsultation,
    String? certificate,
    String? certificateStatus,
    String? city,
    String? country,
    String? experience,
    int? numberOfPeopleRateThisDoctor,
    int? sumOfRating,
    dynamic rating,
  }) {
    return Doctor(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      specialization: specialization ?? this.specialization,
      feePerConsultation: feePerConsultation ?? this.feePerConsultation,
      certificate: certificate ?? this.certificate,
      certificateStatus: certificateStatus ?? this.certificateStatus,
      city: city ?? this.city,
      country: country ?? this.country,
      experience: experience ?? this.experience,
      numberOfPeopleRateThisDoctor:
          numberOfPeopleRateThisDoctor ?? this.numberOfPeopleRateThisDoctor,
      sumOfRating: sumOfRating ?? this.sumOfRating,
      rating: rating ?? this.rating,
    );
  }
}
