import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth.dart';
import 'package:newmyanonamousepdf/bloc/register/register.dart';
import 'package:newmyanonamousepdf/service/auth_service.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationNotAuthenticated) {
              return _AuthForm();
            }
            Navigator.of(context).pop();
            return const Text('Se devería volver para atras');
          },
        ),
      ),
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
      child: BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(authBloc, authService),
        child: _RegisterForm(),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  @override
  __RegisterFormState createState() => __RegisterFormState();
}

class __RegisterFormState extends State<_RegisterForm>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifyPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final _registerBloc = BlocProvider.of<RegisterBloc>(context);
    late final AnimationController _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _onRegisterButtonPressed() {
      if (_key.currentState!.validate()) {
        _registerBloc.add(RegisterButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
          verifyPassword: _verifyPasswordController.text,
          email: _emailController.text,
          fullName: _fullNameController.text,
        ));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          if (state is RegisterLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is RegisterSuccess) {
            return RotationTransition(
              turns: Tween<double>(begin: 0, end: 2).animate(CurvedAnimation(
                  parent: _controller, curve: Curves.bounceOut)),
              child: const Icon(
                Icons.done_outline_rounded,
                size: 100,
                color: Colors.green,
              ),
            );
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
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
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null) {
                          return 'User Name is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
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
                        labelText: 'Verify Password',
                        filled: true,
                        isDense: true,
                      ),
                      obscureText: true,
                      controller: _verifyPasswordController,
                      validator: (value) {
                        if (value == null) {
                          return 'Verify Password is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
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
                        labelText: 'Email',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null) {
                          return 'Email is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
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
                        labelText: 'Full Name',
                        filled: true,
                        isDense: true,
                      ),
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null) {
                          return 'Full Name is required.';
                        }
                        return null;
                      },
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
                    onPressed: state is RegisterLoading
                        ? () {}
                        : _onRegisterButtonPressed,
                    child: Text('REGISTER'),
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
