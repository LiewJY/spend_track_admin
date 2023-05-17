import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

/*
    this class is used to view the states
*/

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    log("onChange $bloc : $change");
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    log("onClose $bloc ");
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    log("onCreate $bloc ");
    super.onCreate(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log("onError $bloc : $error");
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log("onEvent $bloc : $event");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    log("onEvent $onTransition : $transition");
  }
}
