import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:track_admin/repositories/models/category.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    final cf = FirebaseFunctions.instance;
    final db = FirebaseFirestore.instance;

    List<SpendingCategory> categories = [];
    Future<void> test() async {
      try {
        // final ref = db.collection('test').doc("0GwekMNrfUZqkaf7nJy0").withConverter(
        //       fromFirestore: SpendingCategory.fromFirestore,
        //       toFirestore: (SpendingCategory city, _) => city.toFirestore(),
        //     );
        // final docSnap = await ref.get();
        // final city = docSnap.data(); // Convert to City object
        // if (city != null) {
        //   print(city);
        // } else {
        //   log("No such document.");
        // }
            categories.clear();

        final ref = db.collection('test').withConverter(
              fromFirestore: SpendingCategory.fromFirestore,
              toFirestore: (SpendingCategory city, _) => city.toFirestore(),
            );
        final docSnap = await ref.get().then((value) {
          for (var element in value.docs) {
            // log('herererrr');
            // print(element.data());
            // element.data();

            categories.add(element.data());
          }
        });

//todo
        log('print for eqacj');
        categories.forEach((element) {
          log(element.toString());
        });
// final city = docSnap;
        // db.collection('test').get().then(
        //   (querySnapshot) {
        //     for (var docSnapshot in querySnapshot.docs) {
        //       print('${docSnapshot.id} => ${docSnapshot.data()}');

        //     }

        //   },
        //   onError: (e) => print("Error completing: $e"),
        // );

        //function
        // HttpsCallable callable =
        //     FirebaseFunctions.instance.httpsCallable('resetUserPassword');
        // final result = await callable.call(
        //      {
        //     //   //"filter": adminDataList,
        //      },
        //     );
      } catch (e) {
        log(e.toString());
      }
    }

    return ElevatedButton(onPressed: () => test(), child: Text('press me '));
  }
}
