import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:myanonamousepdf_api/myanonamousepdf_api.dart';
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
  final String? error;

  const MyAnonaMousePdf({super.key, this.error});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
        appBarTheme: AppBarTheme(
            backgroundColor:
                const Color.fromARGB(255, 45, 45, 45).withOpacity(0.5),
            elevation: 0),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          /*final authBlock = BlocProvider.of<AuthenticationBloc>(context);
          authBlock.add(AppLoaded());*/
          print("main state: " + state.toString());
          print(error);
          if (state is AuthenticationAuthenticated) {
            return BookListPage(
              context: context,
              user: state.user,
            );
          }
          if (state is AuthenticationInitial) {
            return LoginPage(error: error);
          } else if (state is AuthenticationNotAuthenticated) {
            return LoginPage(error: error);
          } else if (state is AuthenticationErrorState) {
            return LoginPage(error: error);
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
