import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:track_admin/app/view/app.dart';

import 'firebase_options.dart';

Future<void> main() async {
  //firebase integration code
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}