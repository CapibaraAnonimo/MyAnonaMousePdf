part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class LoadBookmarkState extends BookmarkEvent {
  final String id;

  LoadBookmarkState({required this.id});

  @override
  List<Object> get props => [id];
}

class ChangeBookmarkState extends BookmarkEvent {
  final String id;

  ChangeBookmarkState({required this.id});

  @override
  List<Object> get props => [id];
}
