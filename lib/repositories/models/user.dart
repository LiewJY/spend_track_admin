// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'id': id,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] != null ? map['email'] as String : null,
      id: map['id'] as String,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
