import 'package:equatable/equatable.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final JwtUserResponse user;

  ProfileSuccessState({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
