// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'bookCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookCategory _$BookCategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BookCategory',
      json,
      ($checkedConvert) {
        final val = BookCategory(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$BookCategoryToJson(BookCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
