import 'dart:convert';
import 'dart:io';

import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_api/src/models/book_upload.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';

class BookRepository {
  BookRepository({MyanonamousepdfApiClient? myanonamousepdfApiClient})
      : _myanonamousepdfApiClient =
            myanonamousepdfApiClient ?? MyanonamousepdfApiClient();

  final MyanonamousepdfApiClient _myanonamousepdfApiClient;

  Future<Map<String, dynamic>> getAllBooks(
      int page, String token, String refreshToken) async {
    try {
      final response = await _myanonamousepdfApiClient.getAuth(
          'book?page=' + page.toString(), token, refreshToken);

      print('devuelvo el Json');
      return jsonDecode(response.body);
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<List<dynamic>> getOwnBooks(
      String token, String refreshToken) async {
    try {
      final response = await _myanonamousepdfApiClient.getAuth(
          'me/books', token, refreshToken);  

      if (response.statusCode == 404) {
        return [];
      } 

      return jsonDecode(response.body);
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<List<dynamic>> getBookmarks(
      String token, String refreshToken) async {
    try {
      final response = await _myanonamousepdfApiClient.getAuth(
          'bookmarks', token, refreshToken);  

      if (response.statusCode == 404) {
        return [];
      } 

      return jsonDecode(response.body);
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBookById(
      String id, String token, String refreshToken) async {
    try {
      final response = await _myanonamousepdfApiClient.getAuth(
          'book/' + id, token, refreshToken);
      return jsonDecode(response.body);
    } on AuthenticationException {
      rethrow;
    }
  }

  void download(String name, String token, String refreshToken) async {
    try {
      _myanonamousepdfApiClient.downloadFile(
        'book/download/' + name,
        token,
        refreshToken,
        name,
      );
    } on AuthenticationException {
      print("Se llega al repositorio de book");
      rethrow;
    }
  }

  Future<Book> upload(
      BookUpload book, File file, String token, String refreshToken) {
    try {
      return _myanonamousepdfApiClient.upload(book, file, token, refreshToken);
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<bool> isBookmarked(
      String id, String token, String refreshToken) async {
    try {
      return booleanFromString((await _myanonamousepdfApiClient.getAuth(
              "book/bookmark/$id", token, refreshToken))
          .body);
    } on AuthenticationException {
      rethrow;
    }
  }

  Future<bool> changeBookmark(
      String id, String token, String refreshToken) async {
    try {
      return booleanFromString((await _myanonamousepdfApiClient.putAuth(
              "book/bookmark/$id", token, refreshToken))
          .body);
    } on AuthenticationException {
      rethrow;
    }
  }

  bool booleanFromString(String boolean) {
    try {
      boolean = boolean.toLowerCase();
      if (boolean == 'true') {
        return true;
      } else if (boolean == 'false') {
        return false;
      } else {
        throw UnsupportedError(
            'The string should be equals to true or false, but was neither of them');
      }
    } on AuthenticationException {
      rethrow;
    }
  }
}
