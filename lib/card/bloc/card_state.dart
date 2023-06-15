part of 'card_bloc.dart';


enum CardStatus { initial, loading, success, failure }

class CardState extends Equatable {
  final CardStatus status;
  final String error;
  final String success;
  //final List<SpendingCard> CardList;

  const CardState({
    required this.status,
    required this.error,
    required this.success,
    //required this.CardList,
  });

  //initializing
  factory CardState.initial() {
    return const CardState(
      status: CardStatus.initial,
      error: '',
      success: '',
      //CardList: [],
    );
  }

  @override
  List<Object> get props => [status, error, success];

  CardState copyWith({
    CardStatus? status,
    String? error,
    String? success,
    //List<SpendingCard>? CardList,
  }) {
    return CardState(
      status: status ?? this.status,
      error: error ?? this.error,
      success: success ?? this.success,
      //CardList: CardList ?? this.CardList,
    );
  }
}
