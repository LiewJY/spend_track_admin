import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_admin/repositories/models/creditCard.dart';

class CardRepository {
  //firestore instance
  //todo change
  final ref = FirebaseFirestore.instance.collection('cards').withConverter(
      fromFirestore: CreditCard.fromFirestore,
      toFirestore: (CreditCard cat, _) => cat.toFirestore());
  WriteBatch batch = FirebaseFirestore.instance.batch();

  Future<void> addCard({
    required String name,
    required String bank,
    required String cardType,
    required bool isCashback,
    required List<Cashback> cashbacks,
  }) async {
    try {
      final store = CreditCard(
        name: name,
        bank: bank,
        cardType: cardType,
        isCashback: isCashback,
      );
      await ref
          .add(store)
          .then((value) => {
                cashbacks.forEach((element) {
                  var cashbackRef =
                      ref.doc(value.id).collection('cashbacks').withConverter(fromFirestore: Cashback.fromFirestore, toFirestore: (Cashback cashback, _) => cashback.toFirestore()).doc();
                  batch.set(cashbackRef, element);
                }),
                batch.commit(),
              })
          .onError((e, _) => throw e.toString());

      //.onError((e, _) => throw e.toString());
    } catch (e) {
      log('errror      ' + e.toString());
      throw e.toString();
    }
  }
}
