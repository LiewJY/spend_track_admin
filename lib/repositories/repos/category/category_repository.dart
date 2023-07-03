import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:track_admin/repositories/models/category.dart';

class CategoryRepository {
  //firestore instance
  final ref = FirebaseFirestore.instance.collection('categories').withConverter(
      fromFirestore: SpendingCategory.fromFirestore,
      toFirestore: (SpendingCategory cat, _) => cat.toFirestore());

  List<SpendingCategory> categories = [];

  Future<List<SpendingCategory>> getCategories() async {
    categories.clear();
    try {
      await ref.get().then((querySnapshot) {
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

  Future<void> addCategory({
    required String name,
    required String description,
  }) async {
    try {
      final store = SpendingCategory(
        name: name,
        description: description,
      );
      await ref.doc().set(store).onError((e, _) => throw e.toString());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateCategory({
    required String uid,
    required String name,
    required String description,
  }) async {
    try {
      final store = SpendingCategory(
        name: name,
        description: description,
      );
      await ref.doc(uid).set(store).onError((e, _) => throw e.toString());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteCategory({required String uid}) async {
    try {
      await ref.doc(uid).delete().onError((e, _) => throw e.toString());
    } catch (e) {
      throw e.toString();
    }
  }
}
