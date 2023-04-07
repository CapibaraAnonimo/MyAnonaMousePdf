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
          userName: $checkedConvert('user_name', (v) => v as String),
          fullName: $checkedConvert('full_name', (v) => v as String),
          avatar: $checkedConvert('avatar', (v) => v as String),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'userName': 'user_name',
        'fullName': 'full_name',
        'createdAt': 'created_at'
      },
    );
