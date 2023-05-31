//todo
// import 'package:flutter/material.dart';
// import 'package:track_admin/l10n/l10n.dart';
// import 'package:track_admin/widgets/widgets.dart';
// import 'package:track_theme/track_theme.dart';

// class AdminManagementDialog extends StatefulWidget {
//   const AdminManagementDialog({super.key});

//   //AdminManagementDialog({super.key, required this.aa});
//   //final int aa;

//   @override
//   State<AdminManagementDialog> createState() => _AdminManagementDialogState();
// }

// class _AdminManagementDialogState extends State<AdminManagementDialog> {
//   @override
//   Widget build(BuildContext context) {
//     final l10n = context.l10n;
//     return Dialog(
//       child: SingleChildScrollView(
//         //add new admin form
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: 500,
//           ),
//           child: Padding(
//             padding: AppStyle.modalPadding,
//             child: Form(
//               key: addAdminForm,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         l10n.addAdmin,
//                         style: Theme.of(context).textTheme.headlineSmall,
//                       ),
//                     ],
//                   ),
//                   AppStyle.sizedBoxSpace,
//                   NameField(controller: _nameController),
//                   AppStyle.sizedBoxSpace,
//                   EmailField(controller: _emailController),
//                   AppStyle.sizedBoxSpace,
//                   PasswordField(controller: _passwordController),
//                   AppStyle.sizedBoxSpace,
//                   ConfirmPasswordField(
//                       controller: _confirmPasswordController,
//                       password: _passwordController),
//                   AppStyle.sizedBoxSpace,
//                   FilledButton(
//                     style: AppStyle.fullWidthButton,
//                     onPressed: () => addAdmin(),
//                     child: Text(l10n.add),
//                   ),
//                   AppStyle.sizedBoxSpace,
//                   OutlinedButton(
//                     style: AppStyle.fullWidthButton,
//                     onPressed: () => Navigator.pop(context),
//                     child: Text(l10n.cancel),
//                   ),
//                   AppStyle.sizedBoxSpace,
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
