import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Login {
  const Login({
    required this.username,
    required this.password,
  });

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);

  final String username;
  final String password;
}
