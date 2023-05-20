import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:myanonamousepdf_api/src/models/book_upload.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart'
    as repo;

abstract class BookService {
  Future<List<Book>> getAllBooks(int page);
  Future<Book> getBookById(String id);
  void download(String name);
  void upload(BookUpload book, File file);
  Future<bool> isBookmarked(String id);
  Future<bool> changeBookmark(String id);
  Future<List<Book>> getOwnBooks();
  Future<List<Book>> getBookmarks();
}

class JwtBookService extends BookService {
  repo.BookRepository _bookRepository = repo.BookRepository();
  final box = GetStorage();

  JwtBookService() {}

  @override
  Future<List<Book>> getAllBooks(int page) async {
    try {
      JwtUserResponse user =
          JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
      Map<String, dynamic> response = await _bookRepository.getAllBooks(
          page, user.token, user.refreshToken);
      print(
          'guardo las cosas antes de convertirlo y guardar datos importantes');

      List<dynamic> list = response['content'];
      box.write('currentPage', response['number']);
      box.write('maxPages', response['totalPages']);
      List<Book> bookList = [];
      print(list.length);
      for (var book in list) {
        print(book['uploader']['createdAt']);
        print(DateTime.now());
        bookList.add(Book.fromJson(book));
        print(bookList);
      }
      print('devuelvo la lista de libros ya hecha');
      return bookList;
    } on AuthenticationException {
      rethrow;
    }
  }

  @override
  Future<Book> getBookById(String id) async {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
    Map<String, dynamic> response =
        await _bookRepository.getBookById(id, user.token, user.refreshToken);
    return Book.fromJson(response);
  }

  @override
  void download(String name) async {
    try {
      JwtUserResponse user =
          JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
      _bookRepository.download(
        name,
        user.token,
        user.refreshToken,
      );
    } on AuthenticationException {
      print("Se llega al servicio de book");
      rethrow;
    }
  }

  @override
  Future<Book> upload(BookUpload book, File file) async {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
    return _bookRepository.upload(book, file, user.token, user.refreshToken);
  }

  @override
  Future<bool> isBookmarked(String id) async {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
    return await _bookRepository.isBookmarked(
        id, user.token, user.refreshToken);
  }

  @override
  Future<bool> changeBookmark(String id) async {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
    return await _bookRepository.changeBookmark(
        id, user.token, user.refreshToken);
  }

  @override
  Future<List<Book>> getOwnBooks() async {
    try {
      JwtUserResponse user =
          JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
      List<dynamic> list =
          await _bookRepository.getOwnBooks(user.token, user.refreshToken);

      List<Book> bookList = [];
      print(list.length);
      for (var book in list) {
        print(book['uploader']['createdAt']);
        print(DateTime.now());
        bookList.add(Book.fromJson(book));
        print(bookList);
      }
      print('devuelvo la lista de libros ya hecha');
      return bookList;
    } on AuthenticationException {
      rethrow;
    }
  }

  @override
  Future<List<Book>> getBookmarks() async {
    try {
      JwtUserResponse user =
          JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
      List<dynamic> list =
          await _bookRepository.getBookmarks(user.token, user.refreshToken);

      List<Book> bookList = [];
      print(list.length);
      for (var book in list) {
        print(book['uploader']['createdAt']);
        print(DateTime.now());
        bookList.add(Book.fromJson(book));
        print(bookList);
      }
      print('devuelvo la lista de libros ya hecha');
      return bookList;
    } on AuthenticationException {
      rethrow;
    }
  }
}
