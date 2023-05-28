import 'package:bloc/bloc.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:newmyanonamousepdf/bloc/change_avatar/change_avatar_event.dart';
import 'package:newmyanonamousepdf/bloc/change_avatar/change_avatar_state.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';

class ChangeAvatarBloc extends Bloc<ChangeAvatarEvent, ChangeAvatarState> {
  final AuthenticationService authService = JwtAuthenticationService();

  ChangeAvatarBloc() : super(ChangeAvatarInitial()) {
    on<ClickEditButtonEvent>(changeAvatar);
  }

  changeAvatar(
    ClickEditButtonEvent event,
    Emitter<ChangeAvatarState> emit,
  ) async {
    try {
      emit(ChangeAvatarLoading());

      JwtUserResponse user = await authService.changeAvatar(event.file);

      emit(ChangeAvatarSuccess(user: user));
    } on AuthenticationException catch (e) {
      emit(ChangeAvatarAuthenticationErrorState(error: e.toString()));
    }
  }
}
