import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_theme/track_theme.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  const DeleteConfirmationDialog({
    super.key,
    required this.dialogTitle,
    required this.description,
    required this.action,
    this.data,
  });

  final String dialogTitle;
  final String description;
  final action;
  final data;

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: SingleChildScrollView(
          child: Padding(
            padding: AppStyle.modalPadding,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.dialogTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        // l10n.adding(widget.data!.name.toString()),
                        widget.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                AppStyle.sizedBoxSpace,
                FilledButton(
                  style: AppStyle.fullWidthButton,
                  onPressed: widget.action,
                  child: Text(l10n.delete),
                ),
                AppStyle.sizedBoxSpace,
                OutlinedButton(
                  style: AppStyle.fullWidthButton,
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                // AppStyle.sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
