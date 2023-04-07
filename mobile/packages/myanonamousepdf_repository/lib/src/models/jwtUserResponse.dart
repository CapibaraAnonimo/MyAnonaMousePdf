import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jwtUserResponse.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class JwtUserResponse extends Equatable {
  const JwtUserResponse({
    required this.token,
    required this.refreshToken,
    required this.id,
    required this.userName,
    required this.fullName,
    required this.avatar,
    required this.createdAt,
  });

  factory JwtUserResponse.fromJson(Map<String, dynamic> json) =>
      _$JwtUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JwtUserResponseToJson(this);

  final String token;
  final String refreshToken;
  final String id;
  final String userName;
  final String fullName;
  final String avatar;
  final String createdAt;

  @override
  List<Object> get props =>
      [token, refreshToken, id, userName, fullName, avatar /*, createdAt*/];
}
