import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newmyanonamousepdf/service/book_service.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';

import 'bookmark_list_event.dart';
import 'bookmark_list_state.dart';

class BookmarkListBloc extends Bloc<BookmarkListEvent, BookmarkListState> {
  final BookService _bookService = JwtBookService();
  
  BookmarkListBloc() : super(BookmarksListInitial()) {
    on<LoadBookmarks>(_onLoadBookmarksState);
  }

  _onLoadBookmarksState(
    LoadBookmarks event,
    Emitter<BookmarkListState> emit,
  ) async {
    emit(BookmarksLoading());

    List<Book> list = await _bookService.getBookmarks();

    emit(BookmarksSuccess(books: list));
  }
}
