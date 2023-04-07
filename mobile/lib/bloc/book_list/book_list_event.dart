import 'package:equatable/equatable.dart';

abstract class BookListEvent extends Equatable {
  const BookListEvent();

  @override
  List<Object> get props => [];
}

class Loading extends BookListEvent {
  final int page;

  Loading({this.page = 0});

  @override
  List<Object> get props => [page];
}

class BookPressed extends BookListEvent {
  final String id;

  BookPressed({required this.id});

  @override
  List<Object> get props => [id];
}
