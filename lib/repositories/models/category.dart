// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SpendingCategory extends Equatable {
  const SpendingCategory({
    this.uid,
    this.name,
    this.description,
    this.color,
  });

  final String? uid;
  final String? name;
  final String? description;
  final String? color;

  //convert firestore format into object
  factory SpendingCategory.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return SpendingCategory(
      uid: snapshot.id,
      name: data?['name'],
      description: data?['description'],
      color: data?['color'],
    );
  }

  //convert object into firestore format
  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (color != null) "color": color,
    };
  }

  factory SpendingCategory.fromJson(dynamic jsonString) {
    final regex = RegExp(r'(\w+)\s*:\s*([\w\s]+)');
    final matches = regex.allMatches(jsonString);

    final jsonMap = <String, String>{};
    for (final match in matches) {
      final key = match.group(1);
      final value = match.group(2);
      jsonMap[key!] = value!;
    }
    return SpendingCategory(
      uid: jsonMap['uid'].toString(),
      name: jsonMap['name'].toString(),
      //  description: json['description'],
    );
  }

  @override
  List<Object?> get props => [uid, name, description];
}
