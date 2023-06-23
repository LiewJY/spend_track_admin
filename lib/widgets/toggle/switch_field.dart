import 'package:flutter/material.dart';
import 'package:track_admin/l10n/l10n.dart';

class SwitchField extends StatefulWidget {
  const SwitchField({
    super.key,
    required this.label,
    required this.switchState,
    required this.onChanged,
  });

  final String label;
  final bool switchState;
  final onChanged;

  @override
  State<SwitchField> createState() => _SwitchFieldState();
}

class _SwitchFieldState extends State<SwitchField> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        //todo place into style file
        SizedBox(width: 10),
        Switch(
          value: widget.switchState,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
