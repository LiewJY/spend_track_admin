import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:track_admin/repositories/models/category.dart';
import 'package:track_admin/repositories/models/wallet.dart';

class WalletRepository {
  //firestore instance
  final ref = FirebaseFirestore.instance.collection('wallets').withConverter(
      fromFirestore: Wallet.fromFirestore,
      toFirestore: (Wallet wallet, _) => wallet.toFirestore());

  List<Wallet> categories = [];

  Future<List<Wallet>> getWallets() async {
    categories.clear();
    try {
      await ref.orderBy('name').get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          categories.add(docSnapshot.data());
        }
      });
      return categories;
    } catch (e) {
      log(e.toString());
      throw 'cannotRetrieveData';
    }
  }

  Future<void> addWallet({
    required String name,
    required String description,
  }) async {
    try {
      final store = Wallet(
        name: name,
        description: description,
      );
      await ref.doc().set(store).onError((e, _) => throw e.toString());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateWallet({
    required String uid,
    required String name,
    required String description,
  }) async {
    try {
      final store = Wallet(
        name: name,
        description: description,
      );
      await ref.doc(uid).set(store).onError((e, _) => throw e.toString());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteWallet({required String uid}) async {
    try {
      await ref.doc(uid).delete().onError((e, _) => throw e.toString());
    } catch (e) {
      throw e.toString();
    }
  }
}
