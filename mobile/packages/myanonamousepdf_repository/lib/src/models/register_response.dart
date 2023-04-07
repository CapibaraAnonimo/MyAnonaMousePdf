import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class RegisterResponse {
  const RegisterResponse({
    required this.id,
    required this.userName,
    required this.avatar,
    required this.fullName,
    required this.createdAt,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);

  final String id;
  final String userName;
  final String avatar;
  final String fullName;
  final String createdAt;
}
