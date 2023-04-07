// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

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
          refreshToken: $checkedConvert('refresh_token', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          userName: $checkedConvert('user_name', (v) => v as String),
          fullName: $checkedConvert('full_name', (v) => v as String),
          avatar: $checkedConvert('avatar', (v) => v as String),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'refreshToken': 'refresh_token',
        'userName': 'user_name',
        'fullName': 'full_name',
        'createdAt': 'created_at'
      },
    );
