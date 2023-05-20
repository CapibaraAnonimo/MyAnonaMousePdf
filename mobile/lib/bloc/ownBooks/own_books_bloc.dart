import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newmyanonamousepdf/bloc/ownBooks/own_books_event.dart';
import 'package:newmyanonamousepdf/bloc/ownBooks/own_books_state.dart';
import 'package:newmyanonamousepdf/service/book_service.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:myanonamousepdf_api/src/myanonamousepdf_api_client.dart';

class OwnBooksBloc extends Bloc<OwnBooksEvent, OwnBooksState> {
  final BookService _bookService = JwtBookService();

  OwnBooksBloc() : super(OwnBooksInitial()) {
    on<LoadOwnBooks>(_onLoadOwnBooks);
  }

  _onLoadOwnBooks(
    LoadOwnBooks event,
    Emitter<OwnBooksState> emit,
  ) async {
    try {
      emit(OwnBooksLoading());

      List<Book> list = await _bookService.getOwnBooks();

      emit(OwnBooksSuccess(books: list));
    } on AuthenticationException catch (e) {
      emit(AuthenticationErrorState(error: e.toString()));
    }
  }
}
