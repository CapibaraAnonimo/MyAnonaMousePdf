import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ChangeAvatarEvent extends Equatable {
  const ChangeAvatarEvent();

  @override
  List<Object> get props => [];
}

class ClickEditButtonEvent extends ChangeAvatarEvent {
  final File file;

  ClickEditButtonEvent({required this.file});

  @override
  List<Object> get props => [file];
}
