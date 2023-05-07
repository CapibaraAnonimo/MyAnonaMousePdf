part of 'bookmark_bloc.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkSuccess extends BookmarkState {
  final bool bookmarkCurrentState;

  BookmarkSuccess({required this.bookmarkCurrentState});
}

class BookmarkError extends BookmarkState {}
