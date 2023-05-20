import 'package:equatable/equatable.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';

abstract class OwnBooksState extends Equatable {
  const OwnBooksState();
  
  @override
  List<Object> get props => [];
}

class OwnBooksInitial extends OwnBooksState {}

class OwnBooksLoading extends OwnBooksState {}

class OwnBooksSuccess extends OwnBooksState {
  final List<Book> books;

  OwnBooksSuccess({required this.books});
}

class AuthenticationErrorState extends OwnBooksState {
  final String error;

  AuthenticationErrorState({required this.error});
}

class OwnBooksError extends OwnBooksState {}
