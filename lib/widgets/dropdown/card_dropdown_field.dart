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
    const DropdownMenuItem(value: 'visa', child: Text('visa')),
    const DropdownMenuItem(value: 'master', child: Text('master')),
    const DropdownMenuItem(value: 'amex', child: Text('amex')),
    const DropdownMenuItem(value: 'union-pay', child: Text('union pay')),
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
