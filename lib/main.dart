import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  // FirebaseFunctions.instanceFor(region: 'us-central1')
  //     .useFunctionsEmulator('localhost', 5001);

  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const App());
}
