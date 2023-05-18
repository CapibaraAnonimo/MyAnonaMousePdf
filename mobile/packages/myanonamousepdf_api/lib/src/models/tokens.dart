import 'package:json_annotation/json_annotation.dart';

part 'tokens.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Tokens {
  const Tokens({
    required this.token,
    required this.refreshToken,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) =>
      _$TokensFromJson(json);

  Map<String, dynamic> toJson() => _$TokensToJson(this);

  final String token;
  final String refreshToken;
}