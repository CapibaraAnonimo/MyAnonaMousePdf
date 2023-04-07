import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth.dart';
import 'package:newmyanonamousepdf/pages/pages.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';
import 'package:newmyanonamousepdf/bloc/login/login.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              if (state is AuthenticationNotAuthenticated) {
                return _AuthForm();
              }
              if (state is AuthenticationFailure) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(state.message),
                    TextButton(
                      //textColor: Theme.of(context).primaryColor,
                      child: Text('Retry'),
                      onPressed: () {
                        authBloc.add(AppLoaded());
                      },
                    )
                  ],
                ));
              }
              // return splash screen
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
          )),
    );
  }
}

class _AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authService = JwtAuthenticationService();
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authBloc, authService),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      if (_key.currentState!.validate()) {
        _loginBloc.add(LoginInWithUsernameButtonPressed(
            username: _emailController.text,
            password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoginSuccess) {
            Navigator.of(context).pop();
          }
          return Form(
            key: _key,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(
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
                      labelText: 'Username',
                      filled: true,
                      isDense: true,
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null) {
                        return 'Email is required.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    style: TextStyle(
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
                      labelText: 'Password',
                      filled: true,
                      isDense: true,
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null) {
                        return 'Password is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  //RaisedButton(
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    //color: Theme.of(context).primaryColor,
                    //textColor: Colors.white,
                    //padding: const EdgeInsets.all(16),
                    //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                    child: Text(
                      'LOG IN',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed:
                        state is LoginLoading ? () {} : _onLoginButtonPressed,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String error) {
    /*Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));*/

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
