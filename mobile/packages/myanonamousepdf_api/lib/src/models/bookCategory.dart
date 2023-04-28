import 'package:json_annotation/json_annotation.dart';

part 'bookCategory.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class BookCategory {
  const BookCategory({
    required this.id,
    required this.name,
  });

  factory BookCategory.fromJson(Map<String, dynamic> json) =>
      _$BookCategoryFromJson(json);

  final String id;
  final String name;
}