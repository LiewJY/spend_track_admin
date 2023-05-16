import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/repositories/repos/auth/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository authRepository;
  StreamSubscription<User>? userSubscription;

  AppBloc({required this.authRepository})
      //check if the there are logged in user
      : super(
          authRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    //listen for user changes
    userSubscription = authRepository.user.listen(
      (user) => add(AppUserChanged(user)),
    );

    //user change
    on<AppUserChanged>((event, emit) => {
          emit(event.user.isNotEmpty
              ? AppState.authenticated(event.user)
              : const AppState.unauthenticated())
        });

    //logout
    on<AppLogoutRequested>((event, emit) => {
          //use unawaited --> no need to wait for completion
          unawaited(authRepository.logout())
        });

    @override
    Future<void> close() {
      userSubscription?.cancel();
      return super.close();
    }
  }
}
