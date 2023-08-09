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
        return android;
      case TargetPlatform.iOS:
        return ios;
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
    apiKey: 'AIzaSyDsek7WiPfoztyqrD9Q5A8rLLVn1rsaEpE',
    appId: '1:1070967731438:web:2532195146fa23f447afff',
    messagingSenderId: '1070967731438',
    projectId: 'awoof-4785e',
    authDomain: 'awoof-4785e.firebaseapp.com',
    storageBucket: 'awoof-4785e.appspot.com',
    measurementId: 'G-54HZL3JDW7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnOSna57JGW7tXmt4by1EL2rxyFbBzj_0',
    appId: '1:1070967731438:android:cee36e705241c22447afff',
    messagingSenderId: '1070967731438',
    projectId: 'awoof-4785e',
    storageBucket: 'awoof-4785e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACNjE0TYCdf8QC9f2aWFTAJ62BGHIFhpE',
    appId: '1:1070967731438:ios:0b90e8179286a94347afff',
    messagingSenderId: '1070967731438',
    projectId: 'awoof-4785e',
    storageBucket: 'awoof-4785e.appspot.com',
    androidClientId: '1070967731438-l3qhrmtpt0vosnke0iaeqjp5br9svlhs.apps.googleusercontent.com',
    iosClientId: '1070967731438-sm5u6cmkv4v6n54il2obrb810dju8u4b.apps.googleusercontent.com',
    iosBundleId: 'com.awoofApp.io',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyACNjE0TYCdf8QC9f2aWFTAJ62BGHIFhpE',
    appId: '1:1070967731438:ios:0da94d1fad857fa047afff',
    messagingSenderId: '1070967731438',
    projectId: 'awoof-4785e',
    storageBucket: 'awoof-4785e.appspot.com',
    androidClientId: '1070967731438-l3qhrmtpt0vosnke0iaeqjp5br9svlhs.apps.googleusercontent.com',
    iosClientId: '1070967731438-jmg7vh4h6lpau034im7q03o6aclrfc33.apps.googleusercontent.com',
    iosBundleId: 'com.awoof.mobileApp.RunnerTests',
  );
}
