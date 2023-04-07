import 'package:equatable/equatable.dart';

abstract class BookDetailsEvent extends Equatable {
  const BookDetailsEvent();

  @override
  List<Object> get props => [];
}

/*class Loading extends BookListEvent {
  final int page;

  Loading({this.page = 0});

  @override
  List<Object> get props => [page];
}*/

class GetData extends BookDetailsEvent{
  final String id;

  GetData({required this.id});

  @override
  List<Object> get props => [id];
}

class DownloadBook extends BookDetailsEvent {
  final String name;

  DownloadBook({required this.name});

  @override
  List<Object> get props => [name];
}
