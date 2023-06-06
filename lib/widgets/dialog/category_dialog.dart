import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/category/bloc/category_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/management.dart';
import 'package:track_admin/repositories/models/category.dart';
import 'package:track_admin/widgets/form_field/description_field.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({
    super.key,
    required this.dialogTitle,
    required this.actionName,
    required this.action,
    this.data,
  });

  final String dialogTitle;
  final String actionName;
  final String action;
  final SpendingCategory? data;

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final categoryForm = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: AppStyle.dialogMaxWidth,
          child: Padding(
            padding: AppStyle.modalPadding,
            child: Form(
              key: categoryForm,
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
                  AppStyle.sizedBoxSpace,
                  NameField(controller: _nameController),
                  AppStyle.sizedBoxSpace,
                  DescriptionField(controller: _descriptionController),
                  AppStyle.sizedBoxSpace,
                  FilledButton(
                    style: AppStyle.fullWidthButton,
                    onPressed: () => action(widget.action),
                    child: Text(widget.actionName),
                  ),
                  AppStyle.sizedBoxSpace,
                  OutlinedButton(
                    style: AppStyle.fullWidthButton,
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  AppStyle.sizedBoxSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  action(type) {
    if (categoryForm.currentState!.validate()) {
      switch (type) {
        case 'addCategory':
          context.read<CategoryBloc>().add(AddCategoryRequested(
                name: _nameController.text,
                description: _descriptionController.text,
              ));
          break;
        case 'editCategory':
          log('editCategory');
          break;
      }
    }
  }
}
