import 'package:equatable/equatable.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';

abstract class BookListState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookListInitial extends BookListState {}

class BookListLoading extends BookListState {}

class BookListSuccess extends BookListState {
  final List<Book> books;
  final int currentPage;
  final int maxPages;

  BookListSuccess(
      {required this.books, required this.currentPage, required this.maxPages});

  @override
  List<Object> get props => [books, currentPage, maxPages];
}

class BookListFailure extends BookListState {
  final String error;

  BookListFailure({required this.error});

  @override
  List<Object> get props => [error];
}
