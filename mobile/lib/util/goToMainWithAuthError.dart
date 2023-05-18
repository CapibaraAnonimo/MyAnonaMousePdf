import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth_bloc.dart';
import 'package:newmyanonamousepdf/bloc/auth/auth_event.dart';
import 'package:newmyanonamousepdf/main.dart';

void goToMainWithAuthError (BuildContext context, String error) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MyAnonaMousePdf(error: error)),
                (route) => false,
              );
            });
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationError(error: error));
}