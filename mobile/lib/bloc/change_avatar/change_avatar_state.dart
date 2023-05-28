import 'package:equatable/equatable.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';

abstract class ChangeAvatarState extends Equatable {
  const ChangeAvatarState();

  @override
  List<Object> get props => [];
}

class ChangeAvatarInitial extends ChangeAvatarState {}

class ChangeAvatarLoading extends ChangeAvatarState {}

class ChangeAvatarSuccess extends ChangeAvatarState {
  final JwtUserResponse user;

  ChangeAvatarSuccess({required this.user});
}

class ChangeAvatarAuthenticationErrorState extends ChangeAvatarState {
  final String error;

  ChangeAvatarAuthenticationErrorState({required this.error});
}

class ChangeAvatarError extends ChangeAvatarState {}
