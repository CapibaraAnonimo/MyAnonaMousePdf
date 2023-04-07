// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Register _$RegisterFromJson(Map<String, dynamic> json) => Register(
      username: json['username'] as String,
      password: json['password'] as String,
      verifyPassword: json['verifyPassword'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$RegisterToJson(Register instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'verifyPassword': instance.verifyPassword,
      'email': instance.email,
      'fullName': instance.fullName,
    };
