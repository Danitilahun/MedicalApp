class User {
  final String id;
  final String email;
  final String username;
  final String? password;
  String image;
  final String location;
  final String refreshToken;
  final String accessToken;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.role = "",
    this.password,
    this.image = "",
    this.location = "",
    this.refreshToken = "",
    this.accessToken = "",
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      username: json['username'],
      role: json['roles'],
      password: json['password'] ?? "",
      image: json['profileImage'] ?? "",
      location: json['location'] ?? "",
      refreshToken: json['refreshToken'] ?? "",
      accessToken: json['accessToken'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'roles': role,
      'password': password,
      'image': image,
      'location': location,
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };
  }

  User copyWithNewProfile({
    String? id,
    String? email,
    String? username,
    String? password,
    String? image,
    String? location,
    String? refreshToken,
    String? accessToken,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      image: image ?? this.image,
      location: location ?? this.location,
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'image': image,
      'location': location,
      'refreshToken': refreshToken,
      'accessToken': accessToken,
      'role': role,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? "",
      email: map['email'] ?? "",
      username: map['username'] ?? "",
      password: map['password'] ?? "",
      image: map['image'] ?? "",
      location: map['location'] ?? "",
      refreshToken: map['refreshToken'] ?? "",
      accessToken: map['accessToken'] ?? "",
      role: map['role'] ?? "",
    );
  }
}
