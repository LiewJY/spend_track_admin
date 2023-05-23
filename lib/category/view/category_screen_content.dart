import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:track_admin/l10n/l10n.dart';
import 'package:track_admin/widgets/widgets.dart';

import '../../repositories/models/user.dart';
import 'package:firebase_admin/firebase_admin.dart';

class CategoryScereenContent extends StatelessWidget {
  const CategoryScereenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      //color: Colors.amber,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageTitleText(title: l10n.category),
              FilledButton(
                onPressed: () => todo(),
                child: Text(l10n.add),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       fetchUsers();
              //     },
              //     child: Text('user')),
              ElevatedButton(
                  onPressed: () {
                    test();
                  },
                  child: Text('lala')),
              ElevatedButton(
                  onPressed: () {
                    test1();
                  },
                  child: Text('vvvvvvv')),
            ],
          ),
          //todo
        ],
      ),
    );
  }

  todo() {}
}

List<Map<String, dynamic>> adminDataList = [];

pr() {
  print(adminDataList.length);
  print(adminDataList);

  for (Map<String, dynamic> map in adminDataList) {
    String uid = map['uid']; // Access 'uid' instead of 'id'
    print('UID: $uid');
  }
}

test1() async {
  // adminDataList = [];
  await FirebaseFirestore.instance.collection("admins").get().then(
    (querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id}');
        adminDataList.add({'uid': docSnapshot.id});
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
}

//fixme
Future<void> test() async {
   await test1();
  try {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('adminUsers');
    // final result = await callable();

    final result = await callable.call(
      {
        "filter": adminDataList,
      },
    );

    print("res    ${result.data} ");
    List<Map<String, dynamic>> userList = List.from(result.data);
    userList.forEach((user) {
      String uid = user['uid'];
      String email = user['email'];
      print('UID: $uid, Email: $email');
    });

//?   seperator

    // HttpsCallable callable1 = FirebaseFunctions.instance.httpsCallable('user');
    // // final result = await callable();

    // final result1 = await callable1.call(
    //     // {
    //     //   "text": "test text",
    //     // },
    //     );
    // print("     ${result1.data} ");
    // List<Map<String, dynamic>> userList1 = List.from(result1.data);
    // userList1.forEach((user) {
    //   String uid = user['uid'];
    //   String email = user['email'];
    //   print('UID: $uid, Email: $email');
    // });

    log('done ');
  } on FirebaseFunctionsException catch (error) {
    print(error.code);
    print(error.details);
    print(error.message);
  }
}

//todo end

Future<List> getFruit() async {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('listFruit');
  final results = await callable();
  List fruit =
      results.data; // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
  log('done');
  return fruit;
}

// void test() async {
//   List aa = await getFruit();

//   for (String element in aa) {
//     log(element);
//   }
// }
