import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_admin/repositories/models/creditCard.dart';
import 'package:track_admin/repositories/repos/card/card_repository.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository cardRepository;

  CardBloc({required this.cardRepository}) : super(CardState.initial()) {
    on<DisplayAllCardRequested>(_onDisplayAllCardRequested);
    on<DisplayCardCashbackRequested>(_onDisplayCardCashbackRequested);
    on<SetTempRequested>(_onSetTempRequested);

    on<AddCardRequested>(_onAddCardRequested);
     on<UpdateCardRequested>(_onUpdateCardRequested);
    on<DeleteCardRequested>(_onDeleteCardRequested);
  }

  //actions
    _onUpdateCardRequested(
    UpdateCardRequested event,
    Emitter emit,
  ) async {
    if (state.status == CardStatus.loading) return;
    emit(state.copyWith(status: CardStatus.loading));
    try {
      await cardRepository.updateCard(
        uid: event.uid,
        name: event.name,
        bank: event.bank,
        cardType: event.cardType,
        isCashback: event.isCashback,
        cashbacks: event.cashbacks,
      );
      emit(state.copyWith(
        status: CardStatus.success,
        success: 'added',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CardStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onSetTempRequested(
    SetTempRequested event,
    Emitter emit,
  ) async {
    emit(state.copyWith(
      status: CardStatus.success,
      success: 'temp',
      // cardList: cardList,
    ));
  }

  _onDisplayAllCardRequested(
    DisplayAllCardRequested event,
    Emitter emit,
  ) async {
    if (state.status == CardStatus.loading) return;
    emit(state.copyWith(status: CardStatus.loading));
    try {
      List<CreditCard> cardList = await cardRepository.getCards();
      emit(state.copyWith(
        status: CardStatus.success,
        success: 'loadedData',
        cardList: cardList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CardStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onDisplayCardCashbackRequested(
    DisplayCardCashbackRequested event,
    Emitter emit,
  ) async {
    if (state.status == CardStatus.loading) return;
    emit(state.copyWith(status: CardStatus.loading));
    try {
      List<Cashback> cashbackList =
          await cardRepository.getCardCashbacks(event.uid);
      emit(state.copyWith(
        status: CardStatus.success,
        success: 'cashbackLoaded',
        cashbackList: cashbackList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CardStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onAddCardRequested(
    AddCardRequested event,
    Emitter emit,
  ) async {
    if (state.status == CardStatus.loading) return;
    emit(state.copyWith(status: CardStatus.loading));
    try {
      await cardRepository.addCard(
        name: event.name,
        bank: event.bank,
        cardType: event.cardType,
        isCashback: event.isCashback,
        cashbacks: event.cashbacks,
      );
      emit(state.copyWith(
        status: CardStatus.success,
        success: 'added',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CardStatus.failure,
        error: e.toString(),
      ));
    }
  }

  _onDeleteCardRequested(
    DeleteCardRequested event,
    Emitter emit,
  ) async {
    if (state.status == CardStatus.loading) return;
    emit(state.copyWith(status: CardStatus.loading));
    try {
      await cardRepository.deleteCard(uid: event.uid);
      emit(state.copyWith(
        status: CardStatus.success,
        success: 'deleted',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CardStatus.failure,
        error: e.toString(),
      ));
    }
  }

  // _onListCardRequested(
  //   ListCardRequested event,
  //   Emitter emit,
  // ) {
  //   if (state.status == CardStatus.loading) return;
  //   emit(state.copyWith(status: CardStatus.loading));
  //   try {
  //     //todo

  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: CardStatus.failure,
  //       error: e.toString(),
  //     ));
  //   }
  // }

  //   _onListCardRequested(
  //   ListCardRequested event,
  //   Emitter emit,
  // ) {
  //   if (state.status == CardStatus.loading) return;
  //   emit(state.copyWith(status: CardStatus.loading));
  //   try {
  //     //todo
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: CardStatus.failure,
  //       error: e.toString(),
  //     ));
  //   }
  // }
}
