import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/management/management.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class UserManagementDialog extends StatefulWidget {
  const UserManagementDialog({
    super.key,
    required this.dialogTitle,
    required this.actionName,
    required this.action,
    this.data,
  });

  //UserManagementDialog({super.key, required this.aa});
  //final int aa;
  final String dialogTitle;
  final String actionName;
  final String action;
  final User? data;

  @override
  State<UserManagementDialog> createState() => _UserManagementDialogState();
}

class _UserManagementDialogState extends State<UserManagementDialog> {
  final userManagementForm = GlobalKey<FormState>();

  // text field controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // final _nameController = TextEditingController(text: 'name ');
  // final _emailController = TextEditingController(text: 'test@mail.com');
  // final _passwordController = TextEditingController(text: '123456');
  // final _confirmPasswordController = TextEditingController(text: '123456');

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
              key: userManagementForm,
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
                  EmailField(controller: _emailController),
                  AppStyle.sizedBoxSpace,
                  PasswordField(controller: _passwordController),
                  AppStyle.sizedBoxSpace,
                  ConfirmPasswordField(
                    controller: _confirmPasswordController,
                    password: _passwordController,
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
    // if (userManagementForm.currentState!.validate()) {
      switch (type) {
        //todo
        case 'addAdmin':
          context.read<ManagementBloc>().add(AddAdminRequested(
                email: _emailController.text,
                password: _passwordController.text,
                name: _nameController.text,
              ));
          break;
        case 'addUser':
          log('addUser');

          break;
        // default:
      }
    // }
  }
}
