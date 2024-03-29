// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '', //todo replace with own api key
    appId: '1:507351825430:web:7b01681e5712b4242cc937',
    messagingSenderId: '507351825430',
    projectId: 'jy-fyp',
    authDomain: 'jy-fyp.firebaseapp.com',
    storageBucket: 'jy-fyp.appspot.com',
    measurementId: 'G-5FSE7HR4HY',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '', //todo replace with own api key
    appId: '1:507351825430:ios:06f49f9a655a53652cc937',
    messagingSenderId: '507351825430',
    projectId: 'jy-fyp',
    storageBucket: 'jy-fyp.appspot.com',
    iosClientId: '507351825430-eupkb92b0d46rp35lnekgnt22fe49khm.apps.googleusercontent.com',
    iosBundleId: 'com.example.trackAdmin',
  );
}
