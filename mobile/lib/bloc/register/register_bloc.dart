import 'package:bloc/bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth.dart';
import 'package:newmyanonamousepdf/model/login_dto.dart';
import 'package:newmyanonamousepdf/model/register_dto.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  RegisterBloc(AuthenticationBloc authenticationBloc,
      AuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(RegisterInitial()) {
    on<RegisterButtonPressed>(__onRegisterButtonPressed);
  }

  __onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      Register reg = Register(
        username: event.username,
        password: event.password,
        verifyPassword: event.verifyPassword,
        email: event.email,
        fullName: event.fullName,
      );
      print(reg.username);
      final user = await _authenticationService.register(reg.toJson());
      print(user);
      if (user != null) {
        final loggedUser = await _authenticationService.signIn(Login(
          username: event.username,
          password: event.password,
        ));
        if (loggedUser != null) {
          emit(RegisterSuccess());
          _authenticationBloc.add(UserLoggedIn(user: loggedUser));
        }
      } else {
        emit(RegisterFailure(error: 'Something very weird just happened'));
      }
    } on Exception catch (e) {
      emit(RegisterFailure(error: e.toString()));
    }
  }
}
