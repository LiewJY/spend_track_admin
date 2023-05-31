import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/models/user.dart';
import 'package:track_admin/repositories/repositories.dart';

part 'management_event.dart';
part 'management_state.dart';

class ManagementBloc extends Bloc<ManagementEvent, ManagementState> {
  final ManagementRepository managementRepository;
  ManagementBloc({required this.managementRepository})
      : super(ManagementState.initial()) {
    on<DisplayAllAdminRequested>(_onDisplayAllAdminRequested);
  }

  //actions
  _onDisplayAllAdminRequested(
    DisplayAllAdminRequested event,
    Emitter emit,
  ) async {
    if (state.status == ManagementStatus.loading) return;
    emit(state.copyWith(status: ManagementStatus.loading));
    try {
      List<Map<String, dynamic>> adminUsersList =
          await managementRepository.getAdminUsers();
      //convert to list
      List<User> mappedList = adminUsersList.map((data) {
        return User(
          id: data['uid'],
          email: data['email'],
          name: data['displayName'],
          disabled: data['disabled'],
        );
      }).toList();
      emit(state.copyWith(
          status: ManagementStatus.success, adminUsersList: mappedList));
    } catch (e) {
      emit(state.copyWith(
        status: ManagementStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
