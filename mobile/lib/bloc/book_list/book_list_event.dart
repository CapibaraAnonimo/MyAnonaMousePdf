import 'package:equatable/equatable.dart';

abstract class BookListEvent extends Equatable {
  const BookListEvent();

  @override
  List<Object> get props => [];
}

class Loading extends BookListEvent {
  final int page;
  final String? search;

  Loading({this.page = 0, this.search});

  @override
  List<Object> get props => [page, search ?? ''];
}

class BookPressed extends BookListEvent {
  final String id;

  BookPressed({required this.id});

  @override
  List<Object> get props => [id];
}
