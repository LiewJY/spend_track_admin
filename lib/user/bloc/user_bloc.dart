import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc({required this.userRepository}) : super(UserState.initial()) {
    on<DisplayAllUserRequested>(_onDisplayAllUserRequested);
    on<AddUserRequested>(_onAddUserRequested);
    on<DisableUserRequested>(_onDisableUserRequested);
    on<EnableUserRequested>(_onEnableUserRequested);
    on<DeleteUserRequested>(_onDeleteUserRequested);
  }

//actions
  _onDisplayAllUserRequested(
    DisplayAllUserRequested event,
    Emitter emit,
  ) async {
    if (state.status == UserStatus.loading) return;
    emit(state.copyWith(status: UserStatus.loading));
    try {
      List<Map<String, dynamic>> UserUsersList =
          await userRepository.getUsers();
      //convert to list
      List<User> mappedList = UserUsersList.map((data) {
        //print('log aa ' + data.toString());
        return User(
          uid: data['uid'],
          email: data['email'],
          name: data['displayName'],
          disabled: data['disabled'],
        );
      }).toList();

      emit(state.copyWith(
        status: UserStatus.success,
        success: 'loadedData',
        usersList: mappedList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onAddUserRequested(
    AddUserRequested event,
    Emitter emit,
  ) async {
    if (state.status == UserStatus.loading) return;
    emit(state.copyWith(status: UserStatus.loading));
    try {
      await userRepository.addUser(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(state.copyWith(
        status: UserStatus.success,
        success: 'added',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onDisableUserRequested(
    DisableUserRequested event,
    Emitter emit,
  ) async {
    if (state.status == UserStatus.loading) return;
    emit(state.copyWith(status: UserStatus.loading));
    try {
      await userRepository.toggleEnableUser(
        uid: event.uid,
        isEnabled: false,
      );
      emit(state.copyWith(
        status: UserStatus.success,
        success: 'disabled',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onEnableUserRequested(
    EnableUserRequested event,
    Emitter emit,
  ) async {
    if (state.status == UserStatus.loading) return;
    emit(state.copyWith(status: UserStatus.loading));
    try {
      await userRepository.toggleEnableUser(
        uid: event.uid,
        isEnabled: true,
      );
      emit(state.copyWith(
        status: UserStatus.success,
        success: 'enabled',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onDeleteUserRequested(
    DeleteUserRequested event,
    Emitter emit,
  ) async {
    if (state.status == UserStatus.loading) return;
    emit(state.copyWith(status: UserStatus.loading));
    try {
      await userRepository.deleteUser(
        uid: event.uid,
      );
      emit(state.copyWith(
        status: UserStatus.success,
        success: 'deleted',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        error: e.toString(),
      ));
    
    }
  }
}
