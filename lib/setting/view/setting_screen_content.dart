import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/app/app.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/widgets/widgets.dart';
import 'package:track_theme/track_theme.dart';

class SettingScreenContent extends StatelessWidget {
  const SettingScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        PageTitleText(title: l10n.setting),
        FilledButton(
          //style: AppStyle.fullWidthButton,
          onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          child: Text(l10n.logout),
        ),
        // FilledButton(
        //   //style: AppStyle.fullWidthButton,
        //   onPressed: () => log('dddd'),
        //   child: Text(l10n.logout),
        // ),
      ],
    );
  }
}
