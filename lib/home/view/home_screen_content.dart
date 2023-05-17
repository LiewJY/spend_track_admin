import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/app/bloc/app_bloc.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/widgets/widgets.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    //todo

    return Column(
      children: [
        Text("HomeScreenContent"),
      ],
    );
  }
}
