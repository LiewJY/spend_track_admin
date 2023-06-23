import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_admin/repositories/models/creditCard.dart';

class CardRepository {
  //firestore instance
  //todo change
   final ref = FirebaseFirestore.instance.collection('cards').withConverter(
      fromFirestore: CreditCard.fromFirestore,
       toFirestore: (CreditCard cat, _) => cat.toFirestore());


  Future<void> addCard({
    required String name,
    required String bank,
    required String cardType,
    required bool isCashback,
  }) async {
    try {
      final store = CreditCard(
        name: name,
        bank: bank,
        cardType: cardType,
        isCashback: isCashback,
      );
      await ref.doc().set(store).onError((e, _) => throw e.toString());

    } catch (e) {
      throw e.toString();
    }
  }
}
