import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:newmyanonamousepdf/bloc/bookmark_list/bookmark_list_bloc.dart';
import 'package:newmyanonamousepdf/bloc/bookmark_list/bookmark_list_event.dart';
import 'package:newmyanonamousepdf/bloc/bookmark_list/bookmark_list_state.dart';
import 'package:newmyanonamousepdf/pages/books.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'package:newmyanonamousepdf/util/globals.dart' as globals;
import 'package:newmyanonamousepdf/util/goToMainWithAuthError.dart';

import '../bloc/profile/profile.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => UserInfoState();
}

class UserInfoState extends State<UserInfo> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

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
          title: Text(user.userName),
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                            imageUrl: globals.baseUrlApi +
                                "book/download/${user.avatar}",
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(
                                  Icons.error,
                                  size: 100,
                                  color: Colors.white,
                                ),
                            httpHeaders: {
                              "Authorization":
                                  "Bearer " + user.token.toString(),
                              //"Content-Type": "application/json",
                              //"Accept": "application/json",
                            }),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.userName,
                            style: const TextStyle(
                                fontSize: 35, color: Colors.white),
                          ),
                          Text(
                            user.fullName,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                          ),
                          Text(
                            "#${user.id}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            "Joined: ${user.createdAt.substring(0, user.createdAt.length - 10)}",
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: AppBar(
                          automaticallyImplyLeading: false,
                          title: const TabBar(
                            //controller: _controller,
                            tabs: [
                              Tab(
                                icon: Icon(Icons.book),
                              ),
                              Tab(icon: Icon(Icons.bookmark)),
                            ],
                          ),
                        ),
                        body: TabBarView(
                          //controller: _controller,
                          children: [
                            const Center(
                                child: Text(
                              'My Books',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            )),
                            BlocProvider<BookmarkListBloc>(
                              create: (context) =>
                                  BookmarkListBloc()..add(LoadBookmarks()),
                              child: BlocBuilder<BookmarkListBloc,
                                  BookmarkListState>(
                                builder: (context, state) {
                                  if (state is BookmarksLoading) {
                                    return const CircularProgressIndicator();
                                  } else if (state is BookmarksSuccess) {
                                    if (state.books.isEmpty) {
                                      return const Center(
                                          child: Text(
                                        'You have no Bookmarks\nGo find some cool books',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      ));
                                    }
                                    return ListView.builder(
                                      itemCount: state.books.length,
                                      itemBuilder: (context, index) {
                                        print(state.books.length);
                                        return Cards(book: state.books[index]);
                                      },
                                    );
                                  } else if (state
                                      is AuthenticationErrorState) {
                                    goToMainWithAuthError(context, state.error);
                                  }
                                  return const CircularProgressIndicator();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
