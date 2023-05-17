import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/app/cubit/is_admin_cubit.dart';
import 'package:track_admin/home/home.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/unauthorized/unauthorized.dart';

//NOTE: THIS SCREN IS BLANK AND INTEND TO ACT AS A PLACEHOLDER ONLY
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  //for routing
  static Page<void> page() => const MaterialPage<void>(child: LoadingScreen());
  @override
  Widget build(BuildContext context) {
    return FlowBuilder<IsAdminStatus>(
      state: context.select((IsAdminCubit cubit) => cubit.state.status),
      onGeneratePages: routes,
    );
    ;
  }

  List<Page> routes(
    IsAdminStatus state,
    List<Page<dynamic>> pages,
  ) {
    switch (state) {
      case IsAdminStatus.valid:
        return [HomeScreen.page()];

      case IsAdminStatus.invalid:
        //return [UnauthorizedScreen.page()];
        return [UnauthorizedScreen.page()];
    }
    return [Loading.page()];
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  //for routing
  static Page<void> page() => const MaterialPage<void>(child: Loading());
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.youDoNotHavePermissionToAccess,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
