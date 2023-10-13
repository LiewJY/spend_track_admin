import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/models/wallet.dart';
import 'package:track_admin/repositories/repositories.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;
  WalletBloc({required this.walletRepository})
      : super(WalletState.initial()) {
    on<DisplayAllWalletRequested>(_onDisplayAllWalletRequested);
    on<AddWalletRequested>(_onAddWalletRequested);
    on<UpdateWalletRequested>(_onUpdateWalletRequested);
    on<DeleteWalletRequested>(_onDeleteWalletRequested);
  }

  //actions
  _onDisplayAllWalletRequested(
    DisplayAllWalletRequested event,
    Emitter emit,
  ) async {
    if (state.status == WalletStatus.loading) return;
    emit(state.copyWith(status: WalletStatus.loading));
    try {
      List<Wallet> walletList =
          await walletRepository.getWallets();
      emit(state.copyWith(
        status: WalletStatus.success,
        success: 'loadedData',
        walletList: walletList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onAddWalletRequested(
    AddWalletRequested event,
    Emitter emit,
  ) {
    if (state.status == WalletStatus.loading) return;
    emit(state.copyWith(status: WalletStatus.loading));
    try {
      //todo
      walletRepository.addWallet(
        name: event.name,
        description: event.description,
      );
      emit(state.copyWith(
        status: WalletStatus.success,
        success: 'added',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onUpdateWalletRequested(
    UpdateWalletRequested event,
    Emitter emit,
  ) async {
    if (state.status == WalletStatus.loading) return;
    emit(state.copyWith(status: WalletStatus.loading));
    try {
      await walletRepository.updateWallet(
        uid: event.uid,
        name: event.name,
        description: event.description,
      );
      emit(state.copyWith(
        status: WalletStatus.success,
        success: 'updated',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onDeleteWalletRequested(
    DeleteWalletRequested event,
    Emitter emit,
  ) async {
    if (state.status == WalletStatus.loading) return;
    emit(state.copyWith(status: WalletStatus.loading));
    try {
      await walletRepository.deleteWallet(uid: event.uid);
      emit(state.copyWith(
        status: WalletStatus.success,
        success: 'deleted',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
