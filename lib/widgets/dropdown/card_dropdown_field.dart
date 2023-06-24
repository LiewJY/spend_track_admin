import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';

class CardTypeDropDownField extends StatefulWidget {
  const CardTypeDropDownField({
    super.key,
    required this.onChanged,
  });

  final onChanged;

  @override
  State<CardTypeDropDownField> createState() => _CardTypeDropDownFieldState();
}

//dropdown
//todo make it dynamic
List<DropdownMenuItem> get dropdownItems {
  List<DropdownMenuItem> menuItems = [
    const DropdownMenuItem(value: 'Visa', child: Text('Visa')),
    const DropdownMenuItem(value: 'Master', child: Text('Master')),
    const DropdownMenuItem(value: 'Amex', child: Text('Amex')),
    const DropdownMenuItem(value: 'Union Pay', child: Text('Union Pay')),
  ];
  return menuItems;
}

class _CardTypeDropDownFieldState extends State<CardTypeDropDownField> {
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
      items: dropdownItems,
      onChanged: widget.onChanged,
      validator: validator,
    );
  }
}
