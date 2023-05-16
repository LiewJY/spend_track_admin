import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
  });

  final String? email;
  final String id;
  final String? name;

  //represent unauthenticated
  static const empty = User(id: '');

  /// determine is authenticated
  bool get isEmpty => this == User.empty;

  /// determine is unauthenticated
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name];
}
