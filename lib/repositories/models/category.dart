import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SpendingCategory extends Equatable {
  const SpendingCategory({
    this.uid,
    this.name,
    this.description,
  });

  final String? uid;
  final String? name;
  final String? description;

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
    );
  }

  //convert object into firestore format
  Map<String, dynamic> toFirestore() {
    return {
      //if (uid != null) "uid": uid,
      if (name != null) "name": name,
      if (description != null) "description": description,
    };
  }

  @override
  List<Object?> get props => [uid, name, description];
}
