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
