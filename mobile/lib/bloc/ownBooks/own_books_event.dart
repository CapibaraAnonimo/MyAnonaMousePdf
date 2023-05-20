import 'package:equatable/equatable.dart';

abstract class OwnBooksEvent extends Equatable {
  const OwnBooksEvent();

  @override
  List<Object> get props => [];
}

class LoadOwnBooks extends OwnBooksEvent {}
