import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';

class AmountField extends StatefulWidget {
  const AmountField({super.key, required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String? amountValidator(value) {
      if ((double.tryParse(value) ?? 0) <= 0.0) {
        return l10n.amountError;
      } else {
        return null;
      }
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: "${widget.label}*",
        prefix: Text("RM"),
      ),
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      validator: amountValidator,
    );
  }
}
