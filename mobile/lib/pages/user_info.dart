import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';

import '../bloc/profile/profile.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = JwtAuthenticationService();
    final box = GetStorage();
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read("CurrentUser")));

    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(authService)..add(LoadUserProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileSuccessState) {
              print(user.avatar);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                      height: 50,
                      width: 50,
                      imageUrl:
                          "http://192.168.0.159:8080/book/download/${user.avatar}",
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      httpHeaders: {
                        "Authorization": "Basic $user.token",
                        "Content-Type": "application/json",
                        "Accept": "application/json",
                      }),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      state.user.userName,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      state.user.fullName,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      state.user.id,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              );
            } else if (state is ProfileErrorState) {
              // TODO que se vaya al login
              return Center(
                child: Text('Error: ${state.message}'),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
