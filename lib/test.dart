import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    final cf = FirebaseFunctions.instance;
    Future<void> test() async {
      try {
        //function
        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('resetUserPassword');
        final result = await callable.call(
             {
            //   //"filter": adminDataList,
             },
            );
      } catch (e) {
        log(e.toString());
      }
    }

    return ElevatedButton(onPressed: () => test(), child: Text('press me '));
  }
}
