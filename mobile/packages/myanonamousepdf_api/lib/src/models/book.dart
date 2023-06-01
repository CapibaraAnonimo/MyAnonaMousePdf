import 'package:json_annotation/json_annotation.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_api/src/models/commentResponse.dart';

part 'book.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Book {
  const Book({
    required this.id,
    required this.uploadDate,
    required this.uploader,
    required this.amountDownloads,
    required this.category,
    required this.vip,
    required this.book,
    required this.title,
    required this.author,
    required this.description,
    required this.comment,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  final String id;
  final String uploadDate;
  final UserResponse uploader;
  final int amountDownloads;
  final String category;
  final bool vip;
  final String book;
  final String title;
  final String author;
  final String description;
  final List<CommentResponse> comment;
}
