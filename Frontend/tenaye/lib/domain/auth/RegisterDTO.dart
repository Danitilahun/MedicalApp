class RegisterDTO {
  final String email;
  final String username;
  final String password;

  RegisterDTO({
    required this.email,
    required this.username,
    required this.password,
  });

  factory RegisterDTO.fromJson(Map<String, dynamic> json) {
    return RegisterDTO(
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
    };
  }
}
