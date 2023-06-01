import 'package:equatable/equatable.dart';
import 'package:myanonamousepdf_api/src/models/commentResponse.dart';

abstract class BookCommentsState extends Equatable {
  const BookCommentsState();

  @override
  List<Object> get props => [];
}

class BookCommentsInitial extends BookCommentsState {}

class BookCommentsLoading extends BookCommentsState {}

class BookCommentsSuccess extends BookCommentsState {
  final List<CommentResponse> comments;

  BookCommentsSuccess({required this.comments});
}

class AuthenticationErrorState extends BookCommentsState {
  final String error;

  AuthenticationErrorState({required this.error});
}

class OwnBooksError extends BookCommentsState {}
