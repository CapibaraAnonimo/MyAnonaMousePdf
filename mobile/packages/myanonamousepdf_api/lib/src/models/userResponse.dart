import 'package:json_annotation/json_annotation.dart';

part 'userResponse.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserResponse {
  const UserResponse({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.avatar,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  final String id;
  final String userName;
  final String fullName;
  final String avatar;
  final DateTime createdAt;
}
