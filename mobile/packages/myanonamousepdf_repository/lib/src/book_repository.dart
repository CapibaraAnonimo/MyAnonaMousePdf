import 'dart:convert';
import 'dart:io';

import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_api/src/models/book_upload.dart';
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

  Future<Book> upload(BookUpload book, File file, String token, String refreshToken) {
    return _myanonamousepdfApiClient.upload(book, file, token, refreshToken);

  Future<bool> isBookmarked(
      String id, String token, String refreshToken) async {
    return booleanFromString((await _myanonamousepdfApiClient.getAuth(
            "book/bookmark/$id", token, refreshToken))
        .body);
  }

  Future<bool> changeBookmark(
      String id, String token, String refreshToken) async {
    return booleanFromString((await _myanonamousepdfApiClient.putAuth(
            "book/bookmark/$id", token, refreshToken))
        .body);
  }

  bool booleanFromString(String boolean) {
    boolean = boolean.toLowerCase();
    if (boolean == 'true') {
      return true;
    } else if (boolean == 'false') {
      return false;
    } else {
      throw UnsupportedError(
          'The string should be equals to true or false, but was neither of them');
    }
  }
}
