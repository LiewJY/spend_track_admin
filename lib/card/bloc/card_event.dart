part of 'card_bloc.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object> get props => [];
}

class DisplayAllCardRequested extends CardEvent {
  //const AddCategoryRequested({required this.name, required this.description});

  // final String name;
  // final String description;

  @override
  List<Object> get props => [];
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
