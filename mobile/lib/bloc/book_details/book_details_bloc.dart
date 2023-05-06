import 'package:bloc/bloc.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:newmyanonamousepdf/bloc/book_details/book_details.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'package:newmyanonamousepdf/service/book_service.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final AuthenticationService _authenticationService;

  BookDetailsBloc(AuthenticationService authenticationService)
      : assert(authenticationService != null),
        _authenticationService = JwtAuthenticationService(),
        super(BookDetailsInitial()) {
    on<GetData>(_getData);
    on<DownloadBook>(_onDownload);
  }

  _getData(GetData event, Emitter<BookDetailsState> emit) async {
    try {
      emit(BookDetailsLoading());
      final bookService = JwtBookService();
      final Book book = await bookService.getBookById(event.id);
      if (book != null) {
        emit(BookDetailsSuccess(book: book));
      } else {
        emit(BookDetailsFailure(error: 'Something very weird just happened'));
      }
    } on Exception catch (e) {
      emit(BookDetailsFailure(error: e.toString()));
    }
  }

  _onDownload(DownloadBook event, Emitter<BookDetailsState> emit) async {
    //TODO hacer esto cuando se pueda
    try {
      final bookService = JwtBookService();
      bookService.download(event.name);
      if (1 != null) {
        /*emit(BookListSuccess());
        await Future.delayed(const Duration(seconds: 5));
        //_authenticationBloc.add(UserLoggedIn(user: user));*/
      } else {
        emit(BookDetailsFailure(error: 'Something very weird just happened'));
      }
    } on Exception catch (e) {
      emit(BookDetailsFailure(error: e.toString()));
    }
  }
}
