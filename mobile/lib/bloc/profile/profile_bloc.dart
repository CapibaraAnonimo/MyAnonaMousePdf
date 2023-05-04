import 'package:bloc/bloc.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:newmyanonamousepdf/bloc/profile/profile_event.dart';
import 'package:newmyanonamousepdf/bloc/profile/profile_state.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthenticationService _authenticationService;

  ProfileBloc(AuthenticationService authenticationService)
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        super(ProfileInitialState()) {
    //on<AppLoaded>(_onAppLoaded);
    on<LoadUserProfile>(_onLoadUserProfile);
    //on<UserLoggedOut>(_onUserLoggedOut);
  }

  _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    try {
      //await Future.delayed(Duration(milliseconds: 500)); // a simulated delay
      final currentUser = await _authenticationService.getCurrentUser();

      if (currentUser != null) {
        emit(ProfileSuccessState(user: currentUser));
      } else {
        emit(ProfileErrorState(message: 'The user was not found'));
      }
    } on Exception catch (e) {
      emit(ProfileErrorState(
          message: 'An unknown error occurred: ${e.toString()}'));
    }
  }
}
