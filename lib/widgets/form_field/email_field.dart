import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/widgets/form_field/input_action.dart';

class EmailField extends StatefulWidget {
  const EmailField({super.key, required this.controller, this.textInputAction});

  final TextEditingController controller;
  final String? textInputAction;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String? emailValidator(value) {
      if (value.isEmpty) {
        return l10n.pleaseEnterEmail;
      }

      final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9.!#$%&'
        r'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
      );

      if (!emailRegex.hasMatch(value)) {
        return l10n.invalidEmail;
      }

      return null;
    }



    return TextFormField(
      decoration: InputDecoration(
        labelText: "${l10n.email}*",
      ),
      textInputAction: inputAction(widget.textInputAction),
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      validator: emailValidator,
    );
  }
}
