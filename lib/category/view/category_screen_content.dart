import 'dart:convert';
import 'dart:developer';

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
            ],
          ),
          //todo
        ],
      ),
    );
  }

  todo() {}
}

//fixme
Future<void> test() async {
  try {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('addMessage');

    final result = await callable.call(
      {
        "text": "test text",
      },
    );
    log("     ${result.data} ");

    //log( result.data);

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
