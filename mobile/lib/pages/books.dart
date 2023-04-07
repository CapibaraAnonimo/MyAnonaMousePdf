import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth.dart';
import 'package:newmyanonamousepdf/bloc/book_list/book_list.dart';
import 'package:newmyanonamousepdf/pages/pages.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';

class BookListPage extends StatelessWidget {
  BuildContext context;
  final JwtUserResponse? user;

  BookListPage({super.key, this.user, required this.context});

  Widget addBook() {
    if (user != null) {
      return IconButton(
        icon: const Icon(Icons.add_circle_outline_outlined),
        onPressed: () {},
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget log(AuthenticationBloc auth) {
    if (user != null) {
      return IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            auth.add(UserLoggedOut());
          });
    } else {
      return IconButton(
          icon: const Icon(Icons.login),
          onPressed: () {
            logIn();
          });
    }
  }

  void logIn() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final authService = JwtAuthenticationService();
    final _authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider<BookListBloc>(
      create: (context) => BookListBloc(authService),
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 20, 20, 20),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            title: const Text('Books'),
            actions: [
              addBook(),
              log(_authBloc),
            ],
          ),
          body: BodyWidget()),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyState();
}

class _BodyState extends State<BodyWidget> {
  final _scrollController = ScrollController();
  int currentPage = 0;
  int maxPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final authService = JwtAuthenticationService();
    List<Book> books = [];

    return BlocProvider<BookListBloc>(
      create: (context) => BookListBloc(authService),
      child: BlocBuilder<BookListBloc, BookListState>(
        builder: (context, state) {
          final _bookBloc = BlocProvider.of<BookListBloc>(context);

          if (state is BookListSuccess) {
            print('Se entra en success');
            currentPage = state.currentPage;
            maxPage = state.maxPages;
            books.addAll(state.books);
            return ListView.builder(
              /*children: [
                ...booksWidget,
              ],*/
              controller: _scrollController,
              itemCount:
                  books.length + 1, // agregue 1 para cargar más elementos
              itemBuilder: (BuildContext context, int index) {
                if (index < books.length) {
                  return Cards(book: books[index]);
                } else {
                  // cargue más elementos
                  if (currentPage < maxPage - 1) {
                    _bookBloc.add(Loading(page: currentPage + 1));
                    return CircularProgressIndicator();
                  }
                }
              },
            );
          } else if (state is BookListInitial) {
            _bookBloc.add(Loading(page: 0));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    //super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      //context.read<BookListBloc>().add(Loading(page: currentPage + 1));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class Cards extends StatelessWidget {
  final Book book;

  const Cards({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
      child: Card(
        color: Color.fromARGB(255, 32, 32, 32),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetails(id: book.id),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  topLeft: Radius.circular(5),
                ),
                child: Image.network(
                  'https://innovating.capital/wp-content/uploads/2021/05/vertical-placeholder-image.jpg',
                  width: 90,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    width: 275,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: Text(
                            book.title,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                            ),
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                    width: 275,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            book.author,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 145, 145, 145),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: 275,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: DecoratedBox(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 202, 145, 58),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 4),
                                child: Text(
                                  book.category,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                  child: Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 20,
                              )),
                              TextSpan(
                                  text: ' ${book.amountDownloads.toString()}',
                                  style: TextStyle(fontSize: 20))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
