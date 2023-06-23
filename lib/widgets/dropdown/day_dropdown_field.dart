import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';

class SpendingDayDropDownField extends StatefulWidget {
  const SpendingDayDropDownField({
    super.key,
    required this.onChanged,
  });

  final onChanged;

  @override
  State<SpendingDayDropDownField> createState() => _SpendingDayDropDownFieldState();
}

//dropdown
//todo make it dynamic
List<DropdownMenuItem> get dayDropdownItems {
  List<DropdownMenuItem> menuItems = [
    const DropdownMenuItem(value: 'everyday', child: Text('everyday')),
    const DropdownMenuItem(value: 'weekdays', child: Text('weekdays')),
    const DropdownMenuItem(value: 'weekends', child: Text('weekends')),
  ];
  return menuItems;
}

class _SpendingDayDropDownFieldState extends State<SpendingDayDropDownField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String? validator(value) {
      if (value != null) {
        return null;
      } else {
        return l10n.pleaseSelectSpendingDay;
      }
    }

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: l10n.selectSpendingDay,
      ),
      items: dayDropdownItems,
      onChanged: widget.onChanged,
      validator: validator,
    );
  }
}
