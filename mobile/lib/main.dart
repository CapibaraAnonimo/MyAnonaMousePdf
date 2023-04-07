import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'package:newmyanonamousepdf/pages/pages.dart';

void main() {
  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      AuthenticationService authService = JwtAuthenticationService();
      return AuthenticationBloc(authService)..add(AppLoaded());
    },
    child: MyAnonaMousePdf(),
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
}

class MyAnonaMousePdf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Color.fromARGB(255, 30, 30, 30),
        appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(255, 45, 45, 45).withOpacity(0.5),
            elevation: 0),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return BookListPage(
              context: context,
              user: state.user,
            );
          }
          return LoginPage();
        },
      ),
    );
  }
}
