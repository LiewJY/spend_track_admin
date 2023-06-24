
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Cashback extends Equatable {
  const Cashback({
    this.uid,
    this.formId,
    this.category, //? id and name from fb
    this.spendingDay, //list
    this.isRateDifferent, // bool
    //isRateDifferent == TRUE
    this.minSpend, //double - RM
    this.minSpendAchieved, //double - %
    this.minSpendNotAchieved, //double - %
    //END
    //isRateDifferent == FALSE
    this.cashback, //double - %
    //END
    this.isCapped, //bool
    this.cappedAt, //double - RM - ONLY WHEN isCapped == TRUE
  });

  final String? uid;
  //this is for identifying in add and edit
  final int? formId;
   final String? category;
  final String? spendingDay;
  final bool? isRateDifferent;
  final double? minSpend;
  final double? minSpendAchieved;
  final double? minSpendNotAchieved;
  final double? cashback;
  final bool? isCapped;
  final double? cappedAt;

  //convert firestore format into object
  // factory Cashback.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  //   SnapshotOptions? options,
  // ) {
  //   final data = snapshot.data();
  //   return Cashback(
  //     uid: snapshot.id,
  //     name: data?['name'],
  //     description: data?['description'],
  //   );
  // }

  // //convert object into firestore format
  // Map<String, dynamic> toFirestore() {
  //   return {
  //     //if (uid != null) "uid": uid,
  //     if (name != null) "name": name,
  //     if (description != null) "description": description,
  //   };
  // }

  @override
  List<Object?> get props => [uid, formId, category, spendingDay, isRateDifferent, minSpend, minSpendAchieved, minSpendNotAchieved, cashback, isCapped, cappedAt];
}
