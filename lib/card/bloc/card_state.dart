part of 'card_bloc.dart';

enum CardStatus { initial, loading, success, failure }

class CardState extends Equatable {
  final CardStatus status;
  final String error;
  final String success;
  final List<CreditCard> cardList;
  final List<Cashback> cashbackList;

  const CardState({
    required this.status,
    required this.error,
    required this.success,
    required this.cardList,
    required this.cashbackList,
  });

  //initializing
  factory CardState.initial() {
    return const CardState(
      status: CardStatus.initial,
      error: '',
      success: '',
      cardList: [],
      cashbackList: [],
    );
  }

  @override
  List<Object> get props => [status, error, success, cardList, cashbackList];

  CardState copyWith({
    CardStatus? status,
    String? error,
    String? success,
    List<CreditCard>? cardList,
    List<Cashback>? cashbackList,
  }) {
    return CardState(
      status: status ?? this.status,
      error: error ?? this.error,
      success: success ?? this.success,
      cardList: cardList ?? this.cardList,
      cashbackList: cashbackList?? this.cashbackList,
    );
  }
}
