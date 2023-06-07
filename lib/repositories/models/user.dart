// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.uid,
    this.email,
    this.name,
    this.disabled,
  });

  final String? email;
  final String uid;
  final String? name;
  final bool? disabled;

  //represent unauthenticated
  static const empty = User(uid: '');

  /// determine is authenticated
  bool get isEmpty => this == User.empty;

  /// determine is unauthenticated
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, uid, name, disabled];

//todo
//fixme remove????
  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'email': email,
  //     'id': id,
  //     'name': name,
  //     'disabled': disabled,
  //   };
  // }

  // factory User.fromMap(Map<String, dynamic> map) {
  //   return User(
  //     email: map['email'] != null ? map['email'] as String : null,
  //     id: map['id'] as String,
  //     name: map['name'] != null ? map['name'] as String : null,
  //     disabled: map['disabled'] != null ? map['disabled'] as bool : null,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory User.fromJson(String source) =>
  //     User.fromMap(json.decode(source) as Map<String, dynamic>);
}
