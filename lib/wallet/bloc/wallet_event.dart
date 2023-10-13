part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class DisplayAllWalletRequested extends WalletEvent {
  const DisplayAllWalletRequested();

  @override
  List<Object> get props => [];
}

class AddWalletRequested extends WalletEvent {
  const AddWalletRequested({required this.name, required this.description});

  final String name;
  final String description;

  @override
  List<Object> get props => [name, description];
}

class UpdateWalletRequested extends WalletEvent {
  const UpdateWalletRequested(
      {required this.uid, required this.name, required this.description});

  final String uid;
  final String name;
  final String description;

  @override
  List<Object> get props => [name, description];
}

class DeleteWalletRequested extends WalletEvent {
  const DeleteWalletRequested({required this.uid});

  final String uid;

  @override
  List<Object> get props => [uid];
}
