import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'package:newmyanonamousepdf/service/book_service.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final AuthenticationService _authenticationService = JwtAuthenticationService();
  final BookService _bookService = JwtBookService();
  
  BookmarkBloc() : super(BookmarkInitial()) {
    on<LoadBookmarkState>(_onLoadBookmarkState);
    on<ChangeBookmarkState>(_onChangeBookmarkState);
  }

  _onLoadBookmarkState(
    LoadBookmarkState event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());

    bool bookmarked = await _bookService.isBookmarked(event.id);

    emit(BookmarkSuccess(bookmarkCurrentState: bookmarked));
  }

    _onChangeBookmarkState(
    ChangeBookmarkState event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());

    bool bookmarked = await _bookService.changeBookmark(event.id);

    emit(BookmarkSuccess(bookmarkCurrentState: bookmarked));
  }
}
