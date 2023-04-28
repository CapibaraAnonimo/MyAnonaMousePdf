import 'package:bloc/bloc.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'package:newmyanonamousepdf/service/book_service.dart';
import 'package:myanonamousepdf_repository/src/category_repository.dart';
import 'package:myanonamousepdf_api/src/models/bookCategory.dart';
import 'package:newmyanonamousepdf/service/category_service.dart';
import 'book_list_event.dart';
import 'book_list_state.dart';

class BookListBloc extends Bloc<BookListEvent, BookListState> {
  final AuthenticationService _authenticationService;

  BookListBloc(AuthenticationService authenticationService)
      : assert(authenticationService != null),
        _authenticationService = JwtAuthenticationService(),
        super(BookListInitial()) {
    on<Loading>(_onAppLoaded);
    on<BookPressed>(__onBookPressed);
  }

  _onAppLoaded(
    Loading event,
    Emitter<BookListState> emit,
  ) async {
    print('Se llega al bloc de los librossssssssssssssssssssss');
    final bookService = JwtBookService();
    final categoryService = JwtCategoryService();

    emit(BookListLoading());
    try {
      final currentUser = await _authenticationService.getCurrentUser();
      final books = await bookService.getAllBooks(event.page);
      final currentPage = await _authenticationService.getCurrentPage();
      final maxPages = await _authenticationService.getMaxPages();
      final List<BookCategory> categories = await categoryService.getCategories();

      print('Se ha hecho la llamada y se tengo las cosas de vuelta');
      print(books[0].title);
      print(categories[0].name);

      if (books.length >= 0) {
        emit(BookListSuccess(
            books: books, currentPage: currentPage!, maxPages: maxPages!, categories: categories));
      }
    } on Exception catch (e) {
      emit(
          BookListFailure(error: 'An unknown error occurred: ${e.toString()}'));
    }
  }

  __onBookPressed(BookPressed event, Emitter<BookListState> emit) async {
    try {
      final user = await _authenticationService.getCurrentUser();
      if (user != null) {
        /*emit(BookListSuccess());
        await Future.delayed(const Duration(seconds: 5));
        //_authenticationBloc.add(UserLoggedIn(user: user));*/
      } else {
        emit(BookListFailure(error: 'Something very weird just happened'));
      }
    } on Exception catch (e) {
      emit(BookListFailure(error: e.toString()));
    }
  }
}
