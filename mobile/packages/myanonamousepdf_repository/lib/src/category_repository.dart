import 'dart:convert';

import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_api/src/models/bookCategory.dart';

class CategoryRepository {
  CategoryRepository({MyanonamousepdfApiClient? myanonamousepdfApiClient})
      : _myanonamousepdfApiClient =
            myanonamousepdfApiClient ?? MyanonamousepdfApiClient();

  final MyanonamousepdfApiClient _myanonamousepdfApiClient;

  Future<List<BookCategory>> getCategories() async {
    final response = await _myanonamousepdfApiClient.get('category');
    List<BookCategory> list = [];
    for (var c in response) {
      list.add(BookCategory.fromJson(c));
    }
    return list;
    return (response as List).map((e) => BookCategory.fromJson(e)).toList();
  }
}
