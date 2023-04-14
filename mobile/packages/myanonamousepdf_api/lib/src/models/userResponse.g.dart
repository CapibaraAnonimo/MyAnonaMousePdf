// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'userResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserResponse',
      json,
      ($checkedConvert) {
        final val = UserResponse(
          id: $checkedConvert('id', (v) => v as String),
          userName: $checkedConvert('userName', (v) => v as String),
          fullName: $checkedConvert('fullName', (v) => v as String),
          avatar: $checkedConvert('avatar', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );
