// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Book',
      json,
      ($checkedConvert) {
        final val = Book(
          id: $checkedConvert('id', (v) => v as String),
          uploadDate: $checkedConvert('uploadDate', (v) => v as String),
          uploader: $checkedConvert('uploader',
              (v) => UserResponse.fromJson(v as Map<String, dynamic>)),
          amountDownloads: $checkedConvert('amountDownloads', (v) => v as int),
          category: $checkedConvert('category', (v) => v as String),
          vip: $checkedConvert('vip', (v) => v as bool),
          book: $checkedConvert('book', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          author: $checkedConvert('author', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          comment: $checkedConvert(
              'comment',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      CommentResponse.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'uploadDate': instance.uploadDate,
      'uploader': instance.uploader,
      'amountDownloads': instance.amountDownloads,
      'category': instance.category,
      'vip': instance.vip,
      'book': instance.book,
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
      'comment': instance.comment,
    };
