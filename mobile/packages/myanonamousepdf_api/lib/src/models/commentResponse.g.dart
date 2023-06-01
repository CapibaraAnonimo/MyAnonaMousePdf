// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'commentResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentResponse _$CommentResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CommentResponse',
      json,
      ($checkedConvert) {
        final val = CommentResponse(
          text: $checkedConvert('text', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          userId: $checkedConvert('userId', (v) => v as String),
          commentDate: $checkedConvert('commentDate', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$CommentResponseToJson(CommentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'userId': instance.userId,
      'commentDate': instance.commentDate,
    };
