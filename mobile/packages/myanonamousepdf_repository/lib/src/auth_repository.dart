import 'dart:convert';
import 'dart:io';

import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart'
    as repo;

class AuthRepository {
  AuthRepository({MyanonamousepdfApiClient? myanonamousepdfApiClient})
      : _myanonamousepdfApiClient =
            myanonamousepdfApiClient ?? MyanonamousepdfApiClient();

  final MyanonamousepdfApiClient _myanonamousepdfApiClient;

  Future<JwtUserResponse> login(dynamic auth) async {
    final response = await _myanonamousepdfApiClient.post('auth/login', auth);

    print(jsonDecode(response));
    final loggedUser = JwtUserResponse.fromJson(jsonDecode(response));
    return loggedUser;
  }

  Future<repo.RegisterResponse> register(dynamic auth) async {
    final response =
        await _myanonamousepdfApiClient.post('auth/register', auth);

    final registerUser = repo.RegisterResponse.fromJson(jsonDecode(response));
    print(registerUser);
    return registerUser;
  }

  Future<UserResponse> changeAvatar(
      File file, String token, String refreshToken) async {
    dynamic user = await _myanonamousepdfApiClient.uploadImage(
        'me/avatar', file, token, refreshToken);
    return UserResponse.fromJson(user);
  }
}
