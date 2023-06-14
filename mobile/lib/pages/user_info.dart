import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
import 'package:newmyanonamousepdf/bloc/bookmark_list/bookmark_list_bloc.dart';
import 'package:newmyanonamousepdf/bloc/bookmark_list/bookmark_list_event.dart';
import 'package:newmyanonamousepdf/bloc/bookmark_list/bookmark_list_state.dart';
import 'package:newmyanonamousepdf/bloc/change_avatar/change_avatar_bloc.dart';
import 'package:newmyanonamousepdf/bloc/change_avatar/change_avatar_event.dart';
import 'package:newmyanonamousepdf/bloc/change_avatar/change_avatar_state.dart';
import 'package:newmyanonamousepdf/bloc/ownBooks/own_books_bloc.dart';
import 'package:newmyanonamousepdf/bloc/ownBooks/own_books_event.dart';
import 'package:newmyanonamousepdf/bloc/ownBooks/own_books_state.dart'
    as ownBooksState;
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
                      BlocProvider<ChangeAvatarBloc>(
                        create: (context) => ChangeAvatarBloc(),
                        child: BlocBuilder<ChangeAvatarBloc, ChangeAvatarState>(
                          builder: (context, state) {
                            if (state is ChangeAvatarInitial) {
                              return MainAvatar();
                            } else if (state is ChangeAvatarLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is ChangeAvatarSuccess) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookListPage(
                                            user: state.user,
                                            context: context,
                                          )),
                                  (route) => false,
                                );
                              });
                              return MainAvatar();
                            } else if (state
                                is ChangeAvatarAuthenticationErrorState) {
                              goToMainWithAuthError(context, state.error);
                            }
                            return MainAvatar();
                          },
                        ),
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
                            "Joined: ${user.createdAt}",
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
                            BlocProvider<OwnBooksBloc>(
                              create: (context) =>
                                  OwnBooksBloc()..add(LoadOwnBooks()),
                              child: BlocBuilder<OwnBooksBloc,
                                  ownBooksState.OwnBooksState>(
                                builder: (context, state) {
                                  if (state is ownBooksState.OwnBooksLoading) {
                                    return const CircularProgressIndicator();
                                  } else if (state
                                      is ownBooksState.OwnBooksSuccess) {
                                    if (state.books.isEmpty) {
                                      return const Center(
                                          child: Text(
                                        'You haven\'t upload any books\nGo write some cool books',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                        textAlign: TextAlign.center,
                                      ));
                                    }
                                    return ListView.builder(
                                      itemCount: state.books.length,
                                      itemBuilder: (context, index) {
                                        print(state.books.length);
                                        return Cards(book: state.books[index]);
                                      },
                                    );
                                  } else if (state is ownBooksState
                                      .AuthenticationErrorState) {
                                    goToMainWithAuthError(context, state.error);
                                  }
                                  return const CircularProgressIndicator();
                                },
                              ),
                            ),
                            BlocProvider<BookmarkListBloc>(
                              create: (context) =>
                                  BookmarkListBloc()..add(LoadBookmarks()),
                              child: BlocBuilder<BookmarkListBloc,
                                  BookmarkListState>(
                                builder: (context, state) {
                                  final _bookmarksBloc =
                                      BlocProvider.of<BookmarkListBloc>(
                                          context);
                                  if (state is BookmarksLoading) {
                                    return const CircularProgressIndicator();
                                  } else if (state is BookmarksSuccess) {
                                    if (state.books.isEmpty) {
                                      return const Center(
                                          child: Text(
                                        'You have no Bookmarks\nGo find some cool books',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                        textAlign: TextAlign.center,
                                      ));
                                    }
                                    return RefreshIndicator(
                                      onRefresh: () async {
                                        _bookmarksBloc.add(LoadBookmarks());
                                      },
                                      child: ListView.builder(
                                        itemCount: state.books.length,
                                        itemBuilder: (context, index) {
                                          print(state.books.length);
                                          return Cards(
                                              book: state.books[index]);
                                        },
                                      ),
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

class MainAvatar extends StatelessWidget {
  AuthenticationService authService = JwtAuthenticationService();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final changeAvatar = BlocProvider.of<ChangeAvatarBloc>(context);
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read("CurrentUser")));
    print(user.avatar);
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CachedNetworkImage(
              imageBuilder: (context, imageProvider) => Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
              imageUrl: globals.baseUrlApi + "book/download/${user.avatar}",
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 100,
                    color: Colors.white,
                  ),
              httpHeaders: {
                "Authorization": "Bearer " + user.token.toString(),
              }),
          Positioned(
            bottom: -10,
            right: -10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 45, 45, 45).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(100)),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpeg', 'jpg', 'png'],
                      );
                      File file = File(result!.files.single.path!);
                      CroppedFile croppedFile = await ImageCropper().cropImage(
                            sourcePath: file.path,
                            aspectRatioPresets: [CropAspectRatioPreset.square],
                            uiSettings: [
                              AndroidUiSettings(
                                  toolbarTitle: 'Cropper',
                                  toolbarColor: Colors.deepOrange,
                                  toolbarWidgetColor: Colors.white,
                                  initAspectRatio: CropAspectRatioPreset.square,
                                  lockAspectRatio: true),
                              IOSUiSettings(
                                title: 'Cropper',
                              ),
                              WebUiSettings(
                                context: context,
                              ),
                            ],
                          ) ??
                          CroppedFile(file.path);
                      changeAvatar.add(
                          ClickEditButtonEvent(file: File(croppedFile.path)));
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.white,
                    iconSize: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
