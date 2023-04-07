// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RegisterResponse',
      json,
      ($checkedConvert) {
        final val = RegisterResponse(
          id: $checkedConvert('id', (v) => v as String),
          userName: $checkedConvert('userName', (v) => v as String),
          avatar: $checkedConvert('avatar', (v) => (v ?? "") as String),
          fullName: $checkedConvert('fullName', (v) => v as String),
          createdAt: $checkedConvert('createdAt', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'avatar': instance.avatar,
      'fullName': instance.fullName,
      'createdAt': instance.createdAt,
    };
