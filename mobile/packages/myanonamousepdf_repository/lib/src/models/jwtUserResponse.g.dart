// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwtUserResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtUserResponse _$JwtUserResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'JwtUserResponse',
      json,
      ($checkedConvert) {
        final val = JwtUserResponse(
          token: $checkedConvert('token', (v) => v as String),
          refreshToken: $checkedConvert('refreshToken', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          userName: $checkedConvert('userName', (v) => v as String),
          fullName: $checkedConvert('fullName', (v) => v as String),
          avatar: $checkedConvert('avatar', (v) => (v ?? "") as String),
          createdAt: $checkedConvert('createdAt', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$JwtUserResponseToJson(JwtUserResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'id': instance.id,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt,
    };
