import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_admin/repositories/models/cashback.dart';
import 'package:track_admin/repositories/models/creditCard.dart';

class CardRepository {
  //firestore instance
  final ref = FirebaseFirestore.instance.collection('cards').withConverter(
      fromFirestore: CreditCard.fromFirestore,
      toFirestore: (CreditCard card, _) => card.toFirestore());
  //batch write categories into firebase
  WriteBatch batch = FirebaseFirestore.instance.batch();

  List<CreditCard> cards = [];
  Future<List<CreditCard>> getCards() async {
    cards.clear();
    try {
      await ref.get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          cards.add(docSnapshot.data());
        }
      });
      return cards;
    } catch (e) {
      log(e.toString());
      throw 'cannotRetrieveData';
    }
  }

  List<Cashback> cardCashbacks = [];
  Future<List<Cashback>> getCardCashbacks(String uid) async {
    cardCashbacks.clear();
    try {
      //todo
      await ref
          .doc(uid)
          .collection('cashbacks')
          .withConverter(
              fromFirestore: Cashback.fromFirestore,
              toFirestore: (Cashback cashback, _) => cashback.toFirestore())
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          log('repo');
          log(docSnapshot.data().toString());
          cardCashbacks.add(docSnapshot.data());
        }
      });
      return cardCashbacks;
    } catch (e) {
      log(e.toString());
      throw 'cannotRetrieveData';
    }
  }

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
                  var cashbackRef = ref
                      .doc(value.id)
                      .collection('cashbacks')
                      .withConverter(
                          fromFirestore: Cashback.fromFirestore,
                          toFirestore: (Cashback cashback, _) =>
                              cashback.toFirestore())
                      .doc();
                  batch.set(cashbackRef, element);
                }),
                batch.commit(),
              })
          .onError((e, _) => throw e.toString());
    } catch (e) {
      log('errror      ' + e.toString());
      throw e.toString();
    }
  }
}
