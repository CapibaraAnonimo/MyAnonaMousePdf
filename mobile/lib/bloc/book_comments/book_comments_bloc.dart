import 'package:bloc/bloc.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:newmyanonamousepdf/service/book_service.dart';
import 'package:myanonamousepdf_api/src/models/commentResponse.dart';

import 'book_comments_event.dart';
import 'book_comments_state.dart';

class BookCommentsBloc extends Bloc<BookCommentsEvent, BookCommentsState> {
  final BookService _bookService = JwtBookService();

  BookCommentsBloc() : super(BookCommentsInitial()) {
    on<PostCommentEvent>(_onPostComment);
  }

  _onPostComment(
    PostCommentEvent event,
    Emitter<BookCommentsState> emit,
  ) async {
    try {
      emit(BookCommentsLoading());
      print(event.comment.text);

      List<CommentResponse> comments =
          await _bookService.postComment(event.comment, event.id);

      emit(BookCommentsSuccess(comments: comments));
    } on AuthenticationException catch (e) {
      emit(AuthenticationErrorState(error: e.toString()));
    }
  }
}
