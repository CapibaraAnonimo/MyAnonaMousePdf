import 'package:json_annotation/json_annotation.dart';

part 'register_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Register {
  const Register({
    required this.username,
    required this.password,
    required this.verifyPassword,
    required this.email,
    required this.fullName,
  });

  factory Register.fromJson(Map<String, dynamic> json) =>
      _$RegisterFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterToJson(this);

  final String username;
  final String password;
  final String verifyPassword;
  final String email;
  final String fullName;
}
