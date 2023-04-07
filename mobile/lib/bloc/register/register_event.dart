import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String password;
  final String verifyPassword;
  final String email;
  final String fullName;

  RegisterButtonPressed(
      {required this.username,
      required this.password,
      required this.verifyPassword,
      required this.email,
      required this.fullName});

  @override
  List<Object> get props => [username, password];
}
