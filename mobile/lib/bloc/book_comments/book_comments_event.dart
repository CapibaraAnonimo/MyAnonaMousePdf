import 'package:equatable/equatable.dart';
import 'package:myanonamousepdf_api/src/models/commentUpload.dart';

abstract class BookCommentsEvent extends Equatable {
  const BookCommentsEvent();

  @override
  List<Object> get props => [];
}

class PostCommentEvent extends BookCommentsEvent {
  final CommentUpload comment;
  final String id;

  PostCommentEvent({required this.comment, required this.id});

  @override
  List<Object> get props => [comment, id];
}
