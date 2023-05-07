import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:myanonamousepdf_api/src/models/book_upload.dart';

abstract class BookService {
  Future<List<Book>> getAllBooks(int page);
  Future<Book> getBookById(String id);
  void download(String name);
  void upload(BookUpload book, File file);
  Future<bool> isBookmarked(String id);
  Future<bool> changeBookmark(String id);
}

class JwtBookService extends BookService {
  BookRepository _bookRepository = BookRepository();
  final box = GetStorage();

  JwtBookService() {}

  @override
  Future<List<Book>> getAllBooks(int page) async {
    Map<String, dynamic> response = await _bookRepository.getAllBooks(page);
    print('guardo las cosas antes de convertirlo y guardar datos importantes');

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
  }

  @override
  Future<Book> getBookById(String id) async {
    Map<String, dynamic> response = await _bookRepository.getBookById(id);
    return Book.fromJson(response);
  }

  @override
  void download(String name) async {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
    _bookRepository.download(
      name,
      user.token,
      user.refreshToken,
    );
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
    return await _bookRepository.isBookmarked(id, user.token, user.refreshToken);
  }

  @override
  Future<bool> changeBookmark(String id) async {
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read('CurrentUser')));
    return await _bookRepository.changeBookmark(id, user.token, user.refreshToken);
  }
}
