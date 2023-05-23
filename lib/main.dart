import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:track_admin/app/view/app.dart';

import 'firebase_options.dart';
import 'package:cloud_functions/cloud_functions.dart';

Future<void> main() async {
  //firebase integration code
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //for testing local cloud funciton
  FirebaseFunctions.instanceFor(region: 'us-central1').useFunctionsEmulator('localhost', 5001);

     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);



//    FirebaseFirestore.instance.collection("admins").get().then(
//   (querySnapshot) {
//     print("Successfully completed");
//     for (var docSnapshot in querySnapshot.docs) {
//       print('${docSnapshot.id}');
//     }
//   },
//   onError: (e) => print("Error completing: $e"),
// );


  runApp(const App());
}

// FirebaseFunctions.instanceFor(
//   region: 'asia-south1',
// ).useFunctionsEmulator('localhost', 5001);

//example to call cloud fucntion in app

Future<List> getFruit() async {
  HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('listFruit');
  final results = await callable();
  List fruit =
      results.data; // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
  log('done');
  return fruit;
}

void test() async {
  List aa = await getFruit();

  for (String element in aa) {
    log(element);
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ElevatedButton(onPressed:() {
                    test();
                  }
              
              , child: Text('ddddd')),
            ],
          ),
        ),
      ),
    );
  }
}
