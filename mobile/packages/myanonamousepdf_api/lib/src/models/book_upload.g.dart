// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'book_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookUpload _$BookUploadFromJson(Map<String, dynamic> json) => $checkedCreate(
      'BookUpload',
      json,
      ($checkedConvert) {
        final val = BookUpload(
          categoryId: $checkedConvert('categoryId', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          author: $checkedConvert('author', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$BookUploadToJson(BookUpload instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
    };
