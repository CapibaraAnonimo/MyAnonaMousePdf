import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'userResponse.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserResponse extends Equatable {
  const UserResponse({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.avatar,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  final String id;
  final String userName;
  final String fullName;
  final String avatar;
  final String createdAt;

  @override
  List<Object> get props => [id, userName, fullName, avatar, createdAt];
}
