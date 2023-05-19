import 'package:equatable/equatable.dart';

abstract class BookmarkListEvent extends Equatable {
  const BookmarkListEvent();

  @override
  List<Object> get props => [];
}

class LoadBookmarks extends BookmarkListEvent {}
