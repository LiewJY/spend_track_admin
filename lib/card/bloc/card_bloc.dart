import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:track_admin/repositories/repos/card/card_repository.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository cardRepository;

  CardBloc({required this.cardRepository}) : super(CardState.initial()) {
    on<DisplayAllCardRequested>(_onDisplayAllCardRequested);
    on<AddCardRequested>(_onAddCardRequested);
    // on<UpdateCardRequested>(_onUpdateCardRequested);
    // on<DeleteCardRequested>(_onDeleteCardRequested);
  }

  //actions
  _onDisplayAllCardRequested(
    DisplayAllCardRequested event,
    Emitter emit,
  ) {
    if (state.status == CardStatus.loading) return;
    emit(state.copyWith(status: CardStatus.loading));
    try {
      //todo
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
      //todo
      await cardRepository.addCard(
        name: event.name,
        bank: event.bank,
        cardType: event.cardType,
        isCashback: event.isCashback,
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
