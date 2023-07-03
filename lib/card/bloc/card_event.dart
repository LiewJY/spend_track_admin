part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object> get props => [];
}

class DisplayAllCardRequested extends CardEvent {

  @override
  List<Object> get props => [];
}
class DisplayCardCashbackRequested extends CardEvent {
  const DisplayCardCashbackRequested ({required this.uid,});
  final String uid;

  @override
  List<Object> get props => [uid];
}

class AddCardRequested extends CardEvent {
  const AddCardRequested({
    required this.name,
    required this.bank,
    required this.cardType,
    required this.isCashback,
    required this.cashbacks,
  });

  final String name;
  final String bank;
  final String cardType;
  final bool isCashback;
  final List<Cashback> cashbacks;

  @override
  List<Object> get props => [];
}
