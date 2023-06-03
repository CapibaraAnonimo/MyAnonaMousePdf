import 'package:json_annotation/json_annotation.dart';

part 'commentResponse.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CommentResponse {
  const CommentResponse({
    required this.text,
    required this.id,
    required this.username,
    required this.commentDate,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommentResponseToJson(this);

  final String id;
  final String text;
  final String username;
  final String commentDate;
}
