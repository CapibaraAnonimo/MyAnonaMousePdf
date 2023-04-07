import 'dart:convert';

import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart'
    as repo;

class BookRepository {
  BookRepository({MyanonamousepdfApiClient? myanonamousepdfApiClient})
      : _myanonamousepdfApiClient =
            myanonamousepdfApiClient ?? MyanonamousepdfApiClient();

  final MyanonamousepdfApiClient _myanonamousepdfApiClient;

  Future<Map<String, dynamic>> getAllBooks(int page) async {
    final response =
        await _myanonamousepdfApiClient.get('book?page=' + page.toString());

    print('devuelvo el Json');
    return jsonDecode(response);
  }

  Future<Map<String, dynamic>> getBookById(String id) async {
    final response = await _myanonamousepdfApiClient.get('book/' + id);

    return jsonDecode(response);
  }

  void download(String name, String token, String refreshToken) async {
    _myanonamousepdfApiClient.downloadFile(
      'book/download/' + name,
      token,
      refreshToken,
      name,
    );
  }
}
