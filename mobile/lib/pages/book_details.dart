import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:newmyanonamousepdf/bloc/book_details/book_details.dart';
import 'package:newmyanonamousepdf/bloc/bookmark/bookmark_bloc.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';

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
  String id;

  BookDetailsBody({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final authService = JwtAuthenticationService();

    return BlocProvider<BookDetailsBloc>(
        create: (context) => BookDetailsBloc(authService),
        child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
            builder: (context, state) {
          final _bookBloc = BlocProvider.of<BookDetailsBloc>(context);
          if (state is BookDetailsInitial) {
            _bookBloc.add(GetData(id: id));
          } else if (state is BookDetailsLoading) {
            return const CircularProgressIndicator();
          } else if (state is BookDetailsSuccess) {
            Book book = state.book;
            body:
            return Scaffold(
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
                              icon: const Icon(Icons.circle,
                                  color: Colors.amber),
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
                      Image.network(
                        'https://innovating.capital/wp-content/uploads/2021/05/vertical-placeholder-image.jpg',
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
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
                    ],
                  ),
                ),
              ),
            );
          } else if (state is BookDetailsFailure) {}
          return const Text(
            'No deberia de llegar a aqui',
            style: TextStyle(fontSize: 40),
          );
        }));
  }
}
