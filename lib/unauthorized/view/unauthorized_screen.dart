import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/app/app.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_theme/track_theme.dart';

class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({super.key});
  //for routing
  static Page<void> page() =>
      const MaterialPage<void>(child: UnauthorizedScreen());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.verifying,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            AppStyle.sizedBoxSpace,
            FilledButton(
              onPressed: () =>
                  context.read<AppBloc>().add(AppLogoutRequested()),
              child: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }
}
