import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';

class NameField extends StatefulWidget {
  const NameField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String? nameValidator(value) {
      if (value.length >= 2 && value != null) {
        return null;
      } else {
        return l10n.nameEmpty;
      }
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: "${l10n.name}*",
      ),
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.name,
      validator: nameValidator,
    );
  }
}
