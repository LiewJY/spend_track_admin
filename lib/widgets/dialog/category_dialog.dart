import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  late final String uid;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  //for colorpicker
  String? currentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    currentColor =
        '0xff${Theme.of(context).colorScheme.primary.value.toRadixString(16)}';
    //set data for edit / update option
    if (widget.action == 'editCategory') {
      _nameController.text = widget.data!.name!;
      _descriptionController.text = widget.data!.description!;
      currentColor = widget.data!.color!;
    }

    return Dialog(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: AppStyle.dialogMaxWidth,
          child: Padding(
            padding: AppStyle.modalPadding,
            child: Form(
              key: categoryForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    l10n.selectColor,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ColorPicker(
                    pickerAreaHeightPercent: 0.5,
                    // colorPickerWidth: 200,
                    portraitOnly: true,
                    pickerColor: Color(
                        int.parse(currentColor.toString())), //default color
                    onColorChanged: (Color color) {
                      //on color picked
                      currentColor = color.value.toRadixString(16);
                      // log(color.value.toRadixString(16));
                    },
                  ),
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
                color: '0xff$currentColor',
              ));
          break;
        case 'editCategory':
          context.read<CategoryBloc>().add(UpdateCategoryRequested(
                uid: widget.data!.uid!,
                name: _nameController.text,
                description: _descriptionController.text,
                color: '0xff$currentColor',
              ));
          break;
      }
    }
  }
}
