import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';

class DropDownField extends StatefulWidget {
  const DropDownField({
    super.key,
    required this.items,
    required this.onChanged,
  });

  final List<DropdownMenuItem> items;
  final onChanged;

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String? validator(value) {
      if (value != null) {
        return null;
      } else {
        return l10n.pleaseSelectCardType;
      }
    }

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: l10n.selectCardType,
      ),
      items: widget.items,
      onChanged: widget.onChanged,
      validator: validator,
    );
  }
}
