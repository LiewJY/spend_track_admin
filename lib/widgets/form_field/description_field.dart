import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';

class DescriptionField extends StatefulWidget {
  const DescriptionField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String? descriptionValidator(value) {
      if (value.length >= 2 && value != null) {
        return null;
      } else {
        return l10n.descriptionEmpty;
      }
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: "${l10n.description}*",
      ),
      controller: widget.controller,
      keyboardType: TextInputType.text,
      validator: descriptionValidator,
    );
  }
}
