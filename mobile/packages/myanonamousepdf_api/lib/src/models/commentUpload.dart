import 'package:json_annotation/json_annotation.dart';

part 'commentUpload.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CommentUpload {
  const CommentUpload({
    required this.text,
  });

  factory CommentUpload.fromJson(Map<String, dynamic> json) =>
      _$CommentUploadFromJson(json);

  Map<String, dynamic> toJson() => _$CommentUploadToJson(this);

  final String text;
}
