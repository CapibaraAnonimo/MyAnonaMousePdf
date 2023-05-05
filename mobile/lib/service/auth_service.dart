import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart' as api;
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';

abstract class AuthenticationService {
  Future<api.JwtUserResponse?> getCurrentUser();
  Future<api.JwtUserResponse> signIn(dynamic body);
  Future<RegisterResponse?> register(dynamic body);
  Future<void> signOut();
  Future<int?> getCurrentPage();
  Future<int?> getMaxPages();
}

class JwtAuthenticationService extends AuthenticationService {
  late final AuthRepository _authenticationRepository = AuthRepository();
  final box = GetStorage();

  JwtAuthenticationService() {
    /*_authenticationRepository = GetIt.I.get<AuthenticationRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);*/
  }

  @override
  Future<api.JwtUserResponse?> getCurrentUser() async {
    String? loggedUser = box.read("CurrentUser");
    if (loggedUser != null) {
      var user = api.JwtUserResponse.fromJson(jsonDecode(loggedUser));
      return user;
    }
    return null;
  }

  @override //TODO poner esto bien para que de -1 si no existe
  Future<int?> getCurrentPage() async {
    int currentPage = box.read("currentPage") ?? -1;
    if (currentPage != -1) {
      return currentPage;
    }
    return null;
  }

  @override
  Future<int?> getMaxPages() async {
    int maxPages = box.read("maxPages") ?? -1;
    if (maxPages != -1) {
      return maxPages;
    }
    return null;
  }

  @override
  Future<api.JwtUserResponse> signIn(dynamic body) async {
    api.JwtUserResponse response = await _authenticationRepository.login(body);
    await box.write('CurrentUser', jsonEncode(response.toJson()));
    return response;
  }

  @override
  Future<RegisterResponse> register(dynamic body) async {
    RegisterResponse response = await _authenticationRepository.register(body);
    await box.write('CurrentUser', jsonEncode(response.toJson()));
    print(response);
    return response;
  }

  @override
  Future<void> signOut() async {
    await box.remove("CurrentUser");
  }
}
