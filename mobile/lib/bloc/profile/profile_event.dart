import 'package:equatable/equatable.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends ProfileEvent {}
