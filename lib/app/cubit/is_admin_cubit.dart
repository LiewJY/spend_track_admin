import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/repositories.dart';

part 'is_admin_state.dart';

class IsAdminCubit extends Cubit<IsAdminState> {
  final AuthRepository authRepository;

  IsAdminCubit(this.authRepository) : super(IsAdminState.initial());

  Future<void> isAdmin() async {
    if (state.status == IsAdminStatus.loading) return;
    emit(state.copyWith(status: IsAdminStatus.loading));

    try {
      bool isAdmin = await authRepository.isAdmin;
      if (isAdmin) {
        emit(state.copyWith(status: IsAdminStatus.valid));
      } else {
        emit(state.copyWith(status: IsAdminStatus.invalid));
      }
    } catch (e) {
      emit(state.copyWith(status: IsAdminStatus.invalid));
      log(e.toString());
    }
  }
}
