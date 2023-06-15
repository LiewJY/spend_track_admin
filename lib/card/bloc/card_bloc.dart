import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(CardState.initial()) {
    on<CardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
