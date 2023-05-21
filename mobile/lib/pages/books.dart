import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart' as api;
import 'package:myanonamousepdf_repository/myanonamousepdf_repository.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth_event.dart';
import 'package:newmyanonamousepdf/bloc/book_list/book_list.dart';
import 'package:newmyanonamousepdf/pages/pages.dart';
import 'package:newmyanonamousepdf/pages/user_info.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'package:newmyanonamousepdf/service/book_service.dart';
import 'package:myanonamousepdf_api/src/models/bookCategory.dart';
import 'package:newmyanonamousepdf/service/category_service.dart';
import 'package:myanonamousepdf_api/src/models/book.dart';
import 'package:path/path.dart';
import 'package:myanonamousepdf_api/src/models/book_upload.dart';
import '../util/globals.dart' as globals;

class BookListPage extends StatelessWidget {
  BuildContext context;
  final api.JwtUserResponse? user;

  BookListPage({super.key, this.user, required this.context});

  @override
  Widget build(BuildContext context) {
    final authService = JwtAuthenticationService();
    final _authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider<BookListBloc>(
      create: (context) => BookListBloc(authService),
      child: ScreenWidget(
        user: user,
      ),
    );
  }
}

class ScreenWidget extends StatefulWidget {
  const ScreenWidget({super.key, required this.user});
  final api.JwtUserResponse? user;

  @override
  State<ScreenWidget> createState() => _BodyState(user: user);
}

class _BodyState extends State<ScreenWidget> {
  _BodyState({required this.user});
  final _scrollController = ScrollController();
  int currentPage = 0;
  int maxPage = 0;
  final api.JwtUserResponse? user;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = [];
    final authService = JwtAuthenticationService();
    final categoryService = JwtCategoryService();
    final bookService = JwtBookService();
    final _authBloc = BlocProvider.of<AuthenticationBloc>(context);

    uploadFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'epub'],
      );
      List<BookCategory> categories = await categoryService.getCategories();

      if (result != null) {
        File file = File(result.files.single.path!);
        final _titleController = TextEditingController();
        late String _categoryController;
        final _authorController = TextEditingController();
        final _descriptionController = TextEditingController();

        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                title: const Text(
                  "Success",
                  style: TextStyle(
                    color: Color.fromARGB(255, 165, 165, 165),
                  ),
                ),
                content: Text(
                  basename(file.path),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 165, 165, 165),
                  ),
                ),
                actions: [
                  TextFormField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 165, 165, 165),
                    ),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 165, 165, 165),
                      ),
                      fillColor: Color.fromARGB(255, 32, 32, 32),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 165, 165, 165),
                      )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 165, 165, 165),
                        ),
                      ),
                      labelText: 'Title',
                      filled: true,
                      isDense: true,
                    ),
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  DropdownButtonFormField(
                    //value: categories[0],
                    style: const TextStyle(
                      color: Color.fromARGB(255, 165, 165, 165),
                    ),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 165, 165, 165),
                      ),
                      fillColor: Color.fromARGB(255, 32, 32, 32),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 165, 165, 165),
                      )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 165, 165, 165),
                        ),
                      ),
                      labelText: 'Category',
                      filled: true,
                      isDense: true,
                    ),
                    dropdownColor: const Color.fromARGB(255, 32, 32, 32),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      _categoryController = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 165, 165, 165),
                    ),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 165, 165, 165),
                      ),
                      fillColor: Color.fromARGB(255, 32, 32, 32),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 165, 165, 165),
                      )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 165, 165, 165),
                        ),
                      ),
                      labelText: 'Author',
                      filled: true,
                      isDense: true,
                    ),
                    controller: _authorController,
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 165, 165, 165),
                    ),
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 165, 165, 165),
                      ),
                      fillColor: Color.fromARGB(255, 32, 32, 32),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 165, 165, 165),
                      )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 165, 165, 165),
                        ),
                      ),
                      labelText: 'Description',
                      filled: true,
                      isDense: true,
                    ),
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel Upload')),
                      ElevatedButton(
                        onPressed: () async {
                          Book book = await bookService.upload(
                            BookUpload(
                              category: _categoryController,
                              title: _titleController.text,
                              author: _authorController.text,
                              description: _descriptionController.text,
                            ),
                            file,
                          );
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    backgroundColor:
                                        const Color.fromARGB(255, 30, 30, 30),
                                    title: const Text(
                                      "Book Uploaded",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 165, 165, 165),
                                      ),
                                    ),
                                    content: Text(
                                      "${book.title}was uploaded successfully.",
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 165, 165, 165),
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Close")),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookDetails(
                                                            id: book.id),
                                                  ),
                                                );
                                              },
                                              child: const Text("Go to Book"))
                                        ],
                                      )
                                    ]);
                              });
                        },
                        child: const Text('Upload'),
                      ),
                    ],
                  ),
                ],
              );
            });
      } else {
        // User canceled the picker
      }
    }

    Widget addBook() {
      if (user != null) {
        return IconButton(
          icon: const Icon(Icons.add_circle_outline_outlined),
          onPressed: () {
            uploadFile();
          },
        );
      } else {
        return SizedBox.shrink();
      }
    }

    void logIn() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
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

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
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
          title: Row(children: [
            user != null
                ? /*IconButton(
                    onPressed: () {},
                    icon: Image.network(
                        'https://innovating.capital/wp-content/uploads/2021/05/vertical-placeholder-image.jpg'),
                  )*/
                SizedBox(
                    height: 30,
                    width: 30,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserInfo()));
                      },
                      child: CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                          imageUrl: globals.baseUrlApi +
                              "book/download/${user!.avatar}",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          httpHeaders: {
                            "Authorization": "Bearer " + user!.token.toString(),
                            //"Content-Type": "application/json",
                            //"Accept": "application/json",
                          }),
                      /*const CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(
                            'https://innovating.capital/wp-content/uploads/2021/05/vertical-placeholder-image.jpg'),
                      ),*/
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(width: 10),
            const Text('Books')
          ]),
          actions: [
            addBook(),
            log(_authBloc),
          ],
        ),
        body: BlocProvider<BookListBloc>(
          create: (context) => BookListBloc(authService),
          child: BlocBuilder<BookListBloc, BookListState>(
            builder: (context, state) {
              final _bookBloc = BlocProvider.of<BookListBloc>(context);

              if (state is BookListSuccess) {
                currentPage = state.currentPage;
                maxPage = state.maxPages;
                books.addAll(state.books);
                return RefreshIndicator(
                  onRefresh: () async {
                    books = [];
                    _bookBloc.add(Loading(page: 0));
                  },
                  child: ListView.builder(
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
                  ),
                );
              } else if (state is BookListInitial) {
                _bookBloc.add(Loading(page: 0));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
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
