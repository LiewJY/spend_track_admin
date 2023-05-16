import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  //hide and show password
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String? passwordValidator(value) {
      if (value.length >= 6 && value != null) {
        return null;
      } else {
        return l10n.passwordAtLeast6;
      }
    }

    return TextFormField(
      obscureText: obscurePassword,
      decoration: InputDecoration(
          labelText: "${l10n.password}*",
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
