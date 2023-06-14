import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth_bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth_event.dart' as auth;
import 'package:newmyanonamousepdf/bloc/book_comments/book_comments_bloc.dart';
import 'package:newmyanonamousepdf/bloc/book_comments/book_comments_event.dart';
import 'package:newmyanonamousepdf/bloc/book_comments/book_comments_state.dart';
import 'package:newmyanonamousepdf/bloc/book_details/book_details.dart';
import 'package:newmyanonamousepdf/bloc/bookmark/bookmark_bloc.dart';
import 'package:newmyanonamousepdf/main.dart';
import 'package:newmyanonamousepdf/pages/login_page.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'package:newmyanonamousepdf/util/goToMainWithAuthError.dart';
import 'package:myanonamousepdf_api/src/models/commentUpload.dart';
import 'package:myanonamousepdf_api/src/models/commentResponse.dart';
import '../util/globals.dart' as globals;

class BookDetails extends StatelessWidget {
  String id;

  BookDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final authService = JwtAuthenticationService();

    return BlocProvider<BookDetailsBloc>(
      create: (context) => BookDetailsBloc(authService),
      child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
        builder: (context, state) {
          final _bookBloc = BlocProvider.of<BookDetailsBloc>(context);

          return BookDetailsBody(id: id); //Scaffold(appBar: AppBar(), body: );
        },
      ),
    );
  }
}

class BookDetailsBody extends StatelessWidget {
  final box = GetStorage();
  String id;
  final searchController = TextEditingController();

  BookDetailsBody({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final authService = JwtAuthenticationService();
    JwtUserResponse user =
        JwtUserResponse.fromJson(jsonDecode(box.read("CurrentUser")));

    return BlocProvider<BookDetailsBloc>(
        create: (context) => BookDetailsBloc(authService),
        child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
            builder: (context, state) {
          final _bookBloc = BlocProvider.of<BookDetailsBloc>(context);
          if (state is BookDetailsInitial) {
            _bookBloc.add(GetData(id: id));
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookDetailsSuccess) {
            Book book = state.book;
            body:
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text(book.title),
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        book.amountDownloads.toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () =>
                          {_bookBloc.add(DownloadBook(name: book.book))},
                      icon: const Icon(Icons.download)),
                  BlocProvider<BookmarkBloc>(
                      create: (context) => BookmarkBloc(),
                      child: BlocBuilder<BookmarkBloc, BookmarkState>(
                        builder: (context, state) {
                          final _bookmarkBloc =
                              BlocProvider.of<BookmarkBloc>(context);
                          if (state is BookmarkInitial) {
                            _bookmarkBloc.add(LoadBookmarkState(id: book.id));
                            return IconButton(
                              onPressed: () => {},
                              icon: const Icon(Icons.bookmark_border),
                            );
                          } else if (state is BookmarkLoading) {
                            return IconButton(
                              onPressed: () => {},
                              icon:
                                  const Icon(Icons.circle, color: Colors.amber),
                            );
                          } else if (state is BookmarkSuccess) {
                            if (state.bookmarkCurrentState) {
                              return IconButton(
                                onPressed: () => {
                                  _bookmarkBloc
                                      .add(ChangeBookmarkState(id: book.id))
                                },
                                icon: const Icon(Icons.bookmark,
                                    color: Colors.red),
                              );
                            } else {
                              return IconButton(
                                onPressed: () => {
                                  _bookmarkBloc
                                      .add(ChangeBookmarkState(id: book.id))
                                },
                                icon: const Icon(Icons.bookmark_border),
                              );
                            }
                          }
                          return const Text("");
                        },
                      )),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Center(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 350,
                                decoration: BoxDecoration(
                                  //shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain),
                                ),
                              ),
                          imageUrl: globals.baseUrlApi +
                              "book/download/${book.image}",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          httpHeaders: {
                            "Authorization": "Bearer ${user!.token}",
                            //"Content-Type": "application/json",
                            //"Accept": "application/json",
                          }),
                      /*Image.network(
                        'https://innovating.capital/wp-content/uploads/2021/05/vertical-placeholder-image.jpg',
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),*/
                      Text(
                        book.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.055),
                      ),
                      const Divider(color: Colors.white),
                      Text(
                        "By",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.055),
                      ),
                      Text(
                        book.author,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.055),
                      ),
                      const Divider(color: Colors.white),
                      Text(
                        book.description,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.055),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Column(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 45, 45, 45),
                              height: 60,
                              child: const Center(
                                child: Text(
                                  'Comments',
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.white),
                                ),
                              ),
                            ),
                            BlocProvider<BookCommentsBloc>(
                              create: (context) => BookCommentsBloc(),
                              child: BlocBuilder<BookCommentsBloc,
                                  BookCommentsState>(
                                builder: (context, state) {
                                  final bookCommentsBloc =
                                      BlocProvider.of<BookCommentsBloc>(
                                          context);
                                  if (state is BookCommentsInitial) {
                                    return Column(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                          ),
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: book.comment.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 5),
                                                child: CommentWidget(
                                                    comment:
                                                        book.comment[index]),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 165, 165, 165),
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    labelStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 165, 165, 165),
                                                    ),
                                                    fillColor: Color.fromARGB(
                                                        255, 32, 32, 32),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 165, 165, 165),
                                                    )),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 165, 165, 165),
                                                      ),
                                                    ),
                                                    labelText: 'Comment',
                                                    filled: true,
                                                    isDense: true,
                                                  ),
                                                  controller: searchController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  autocorrect: false,
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Comment is required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  if (searchController
                                                      .text.isNotEmpty) {
                                                    final bookCommentsBloc =
                                                        BlocProvider.of<
                                                                BookCommentsBloc>(
                                                            context);

                                                    bookCommentsBloc.add(
                                                      PostCommentEvent(
                                                          comment: CommentUpload(
                                                              text:
                                                                  searchController
                                                                      .text),
                                                          id: book.id),
                                                    );
                                                    searchController.clear();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (state is BookCommentsSuccess) {
                                    return Column(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                          ),
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: state.comments.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 10, 0, 5),
                                                child: CommentWidget(
                                                    comment:
                                                        state.comments[index]),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 165, 165, 165),
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    labelStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 165, 165, 165),
                                                    ),
                                                    fillColor: Color.fromARGB(
                                                        255, 32, 32, 32),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 165, 165, 165),
                                                    )),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 165, 165, 165),
                                                      ),
                                                    ),
                                                    labelText: 'Comment',
                                                    filled: true,
                                                    isDense: true,
                                                  ),
                                                  controller: searchController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  autocorrect: false,
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Comment is required';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  if (searchController
                                                      .text.isNotEmpty) {
                                                    final bookCommentsBloc =
                                                        BlocProvider.of<
                                                                BookCommentsBloc>(
                                                            context);

                                                    bookCommentsBloc.add(
                                                      PostCommentEvent(
                                                          comment: CommentUpload(
                                                              text:
                                                                  searchController
                                                                      .text),
                                                          id: book.id),
                                                    );
                                                    searchController.clear();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                      )
                    ],
                  ),
                ),
              ),
              //bottomNavigationBar:
            );
          } else if (state is BookDetailsFailure) {
          } else if (state is AuthenticationError) {
            goToMainWithAuthError(context, state.error);
          }
          print("Current State: " + state.toString());
          return const Text(
            'No debería de llegar al final de book_details',
            style: TextStyle(fontSize: 40),
          );
        }));
  }
}

class CommentWidget extends StatelessWidget {
  final CommentResponse comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 45, 45, 45),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comment.username,
            style: const TextStyle(fontSize: 15, color: Color.fromRGBO(30, 136, 229, 1)),
            //textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            comment.text,
            style: const TextStyle(fontSize: 15, color: Colors.white),
            //textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            comment.commentDate,
            style: const TextStyle(fontSize: 10, color: Colors.white),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
