abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String password;
  final String confirmPassword;
  final String email;

  RegisterSubmitted({
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.email,
  });
}
