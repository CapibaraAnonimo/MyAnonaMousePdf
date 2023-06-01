// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'commentUpload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentUpload _$CommentUploadFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CommentUpload',
      json,
      ($checkedConvert) {
        final val = CommentUpload(
          text: $checkedConvert('text', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$CommentUploadToJson(CommentUpload instance) =>
    <String, dynamic>{
      'text': instance.text,
    };
