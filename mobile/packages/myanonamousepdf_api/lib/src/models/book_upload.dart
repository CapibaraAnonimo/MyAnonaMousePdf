import 'package:json_annotation/json_annotation.dart';

part 'book_upload.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class BookUpload {
  const BookUpload({
    required this.category,
    required this.title,
    required this.author,
    required this.description,
  });

  factory BookUpload.fromJson(Map<String, dynamic> json) =>
      _$BookUploadFromJson(json);

  Map<String, dynamic> toJson() => _$BookUploadToJson(this);

  final String category;
  final String title;
  final String author;
  final String description;
}
