import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';

class CashbackPercentField extends StatefulWidget {
  const CashbackPercentField({super.key, required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  State<CashbackPercentField> createState() => _CashbackPercentFieldState();
}

class _CashbackPercentFieldState extends State<CashbackPercentField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String? cashbackValidator(value) {
      if ((double.tryParse(value) ?? 0) <= 0.0) {
        return l10n.cashbackError;
      } else {
        return null;
      }
    }

    return TextFormField(
      decoration: InputDecoration(
        labelText: "${widget.label}*",
        suffix: Text('%'),
      ),
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      validator: cashbackValidator,
    );
  }
}
