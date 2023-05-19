import 'package:equatable/equatable.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';

abstract class BookmarkListState extends Equatable {
  const BookmarkListState();

  @override
  List<Object> get props => [];
}

class BookmarksListInitial extends BookmarkListState {}

class BookmarksLoading extends BookmarkListState {}

class BookmarksSuccess extends BookmarkListState {
  final List<Book> books;

  BookmarksSuccess({required this.books});
}

class AuthenticationErrorState extends BookmarkListState {
  final String error;

  AuthenticationErrorState({required this.error});
}

class BookmarksError extends BookmarkListState {}
