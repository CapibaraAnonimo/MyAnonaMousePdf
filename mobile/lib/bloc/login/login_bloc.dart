import 'package:bloc/bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth_bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth_event.dart';
import 'package:newmyanonamousepdf/model/login_dto.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  LoginBloc(AuthenticationBloc authenticationBloc,
      JwtAuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(LoginInitial()) {
    on<LoginInWithUsernameButtonPressed>(__onLogingInWithEmailButtonPressed);
  }

  __onLogingInWithEmailButtonPressed(
    LoginInWithUsernameButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final login = Login(username: event.username, password: event.password);
      print(login.toJson());
      final user = await _authenticationService.signIn(login.toJson());
      if (user != null) {
        _authenticationBloc.add(UserLoggedIn(user: user));
        emit(LoginSuccess());
        emit(LoginInitial());
      } else {
        emit(LoginFailure(error: 'Something very weird just happened'));
      }
    } on Exception catch (err) {
      String error = err.toString();
      int startIndex;
      String mensaje;
      int endIndex;
      if (error.contains("message\":\"")) {
        print(error);
        mensaje = "message\":\"";
        startIndex = error.indexOf(mensaje);
        endIndex = error.indexOf("\",\"path", startIndex);
      } else {
        print(error);
        mensaje = "\"mensaje\":\"";
        startIndex = error.indexOf(mensaje);
        endIndex = error.indexOf("\",\"ruta", startIndex);
      }
      
      emit(LoginFailure(error: '${error.substring(startIndex + mensaje.length, endIndex).trim()}'));





    }
  }
}
