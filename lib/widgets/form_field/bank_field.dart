import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';

class BankField extends StatefulWidget {
  const BankField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<BankField> createState() => _BankFieldState();
}

class _BankFieldState extends State<BankField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String? bankValidator(value) {
      if (value.length >= 2 && value != null) {
        return null;
      } else {
        return l10n.bankEmpty;
      }
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: "${l10n.bank}*",
      ),
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.name,
      validator: bankValidator,
    );
  }
}
