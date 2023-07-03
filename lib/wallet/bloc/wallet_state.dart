part of 'wallet_bloc.dart';

enum WalletStatus { initial, loading, success, failure }

class WalletState extends Equatable {
  final WalletStatus status;
  final String error;
  final String success;
  final List<Wallet> walletList;

  const WalletState({
    required this.status,
    required this.error,
    required this.success,
    required this.walletList,
  });

  //initializing
  factory WalletState.initial() {
    return const WalletState(
      status: WalletStatus.initial,
      error: '',
      success: '',
      walletList: [],
    );
  }

  @override
  List<Object> get props => [status, error, success,walletList];

  WalletState copyWith({
    WalletStatus? status,
    String? error,
    String? success,
    List<Wallet>? walletList,
  }) {
    return WalletState(
      status: status ?? this.status,
      error: error ?? this.error,
      success: success ?? this.success,
      walletList: walletList ?? this.walletList,
    );
  }
}
