import 'dart:developer';

import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_admin/app/app.dart';
import 'package:track_admin/app/bloc/app_bloc.dart';
import 'package:track_admin/app/view/loading_screen.dart';
import 'package:track_admin/bloc_observer.dart';
import 'package:track_admin/home/home.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/login/view/login_screen.dart';
import 'package:track_admin/repositories/repos/auth/auth_repository.dart';
import 'package:track_admin/dtSample.dart';
import 'package:track_admin/unauthorized/unauthorized.dart';
import 'package:track_theme/track_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //create single instance of auth repo
    final authRepository = AuthRepository();

    //bloc
    Bloc.observer = AppBlocObserver();

    return RepositoryProvider.value(
      value: authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(authRepository: authRepository),
          ),
          BlocProvider(
            create: (context) => IsAdminCubit(authRepository),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  //set app theme
  ThemeMode themeMode = ThemeMode.system;

  //todo
  //theme switching
  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return SchedulerBinding.instance.window.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //todo uncomment when complete
      //debugShowCheckedModeBanner: false,
      title: 'track',
      //todo change to changeble --> themeMode
      themeMode: ThemeMode.light,
      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: pageRoute(),
      //home: Test(),
    );
  }

  pageRoute() {
    return FlowBuilder<AppStatus>(
      state: context.select((AppBloc bloc) => bloc.state.status),
      onGeneratePages: routes,
    );
  }

  List<Page> routes(
    AppStatus state,
    List<Page<dynamic>> pages,
  ) {
    switch (state) {
      case AppStatus.authenticated:
      //check if the user is admin
        context.read<IsAdminCubit>().isAdmin();
        return [LoadingScreen.page()];
      case AppStatus.unauthenticated:
        return [LoginScreen.page()];
    }
  }
}
