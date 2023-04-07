// GENERATED CODE - DO NOT MODIFY BY HAND

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
          uploadDate:
              $checkedConvert('uploadDate', (v) => DateTime.parse(v as String)),
          uploader: $checkedConvert('uploader',
              (v) => UserResponse.fromJson(v as Map<String, dynamic>)),
          amountDownloads: $checkedConvert('amountDownloads', (v) => v as int),
          category: $checkedConvert('category', (v) => v as String),
          vip: $checkedConvert('vip', (v) => v as bool),
          book: $checkedConvert('book', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          author: $checkedConvert('author', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'uploader': instance.uploader,
      'amountDownloads': instance.amountDownloads,
      'category': instance.category,
      'vip': instance.vip,
      'book': instance.book,
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
    };
