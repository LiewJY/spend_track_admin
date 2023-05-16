import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';

class ConfirmPasswordField extends StatefulWidget {
  const ConfirmPasswordField(
      {super.key, required this.controller, required this.password});

  final TextEditingController controller;
  final TextEditingController password;

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  //hide and show password
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String? passwordValidator(value) {
      if (value.length >= 6 && value != null) {
        if (widget.controller.text != widget.password.text) {
          return l10n.passwordDoesNotMatch;
        } else {
          return null;
        }
      } else {
        return l10n.passwordAtLeast6;
      }
    }

    return TextFormField(
      obscureText: obscurePassword,
      decoration: InputDecoration(
          labelText: "${l10n.confirmPassword}*",
          suffixIcon: IconButton(
            icon:
                Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          )),
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.visiblePassword,
      validator: passwordValidator,
    );
  }
}
