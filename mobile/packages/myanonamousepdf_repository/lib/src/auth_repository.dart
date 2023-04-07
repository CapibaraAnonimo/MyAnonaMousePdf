import 'dart:convert';

import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart'
    as repo;

class AuthRepository {
  AuthRepository({MyanonamousepdfApiClient? myanonamousepdfApiClient})
      : _myanonamousepdfApiClient =
            myanonamousepdfApiClient ?? MyanonamousepdfApiClient();

  final MyanonamousepdfApiClient _myanonamousepdfApiClient;

  Future<repo.JwtUserResponse> login(dynamic auth) async {
    final response = await _myanonamousepdfApiClient.post('auth/login', auth);

    print(jsonDecode(response));
    final loggedUser = repo.JwtUserResponse.fromJson(jsonDecode(response));
    return loggedUser;
  }

  Future<repo.RegisterResponse> register(dynamic auth) async {
    final response =
        await _myanonamousepdfApiClient.post('auth/register', auth);

    final registerUser = repo.RegisterResponse.fromJson(jsonDecode(response));
    print(registerUser);
    return registerUser;
  }
}
