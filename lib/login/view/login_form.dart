import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/login/login.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final loginForm = GlobalKey<FormState>();

  //text field controllers
  //fixme remove setted value
  final _emailController = TextEditingController(text: 'liewjunyoung@gmail.com');

  final _passwordController = TextEditingController(text: '111111');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: loginForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmailField(
            controller: _emailController,
            textInputAction: 'next',
          ),
          AppStyle.sizedBoxSpace,
          PasswordField(controller: _passwordController),
          AppStyle.sizedBoxSpace,
          FilledButton(
            style: AppStyle.fullWidthButton,
            onPressed: () => login(),
            child: Text(l10n.login),
          ),
        ],
      ),
    );
  }

  void login() {
    if (loginForm.currentState!.validate()) {
      context.read<LoginCubit>().loginWithCredentials(
          email: _emailController.text, password: _passwordController.text);
    }
  }
}
