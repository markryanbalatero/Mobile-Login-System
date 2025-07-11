import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyD3LPaUaXzfONm8Q53VcaZdgRgIhA-TaM8',
    appId: '1:604948792312:web:a0ba0e839e470fcf508c0d',
    messagingSenderId: '604948792312',
    projectId: 'devmark-sample-login',
    authDomain: 'devmark-sample-login.firebaseapp.com',
    storageBucket: 'devmark-sample-login.firebasestorage.app',
    measurementId: 'G-7WV3PFT87V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBW7z7YqeTRaej3xoR5wUnIW_orVGK8oa8',
    appId: '1:604948792312:android:739c22712bb1edfe508c0d',
    messagingSenderId: '604948792312',
    projectId: 'devmark-sample-login',
    storageBucket: 'devmark-sample-login.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6rTJiGJlf0QTcxpNUHbAHDP1ckTMsjPI',
    appId: '1:604948792312:ios:77a341648143bb00508c0d',
    messagingSenderId: '604948792312',
    projectId: 'devmark-sample-login',
    storageBucket: 'devmark-sample-login.firebasestorage.app',
    iosBundleId: 'com.example.mobileLogin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6rTJiGJlf0QTcxpNUHbAHDP1ckTMsjPI',
    appId: '1:604948792312:ios:77a341648143bb00508c0d',
    messagingSenderId: '604948792312',
    projectId: 'devmark-sample-login',
    storageBucket: 'devmark-sample-login.firebasestorage.app',
    iosBundleId: 'com.example.mobileLogin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD3LPaUaXzfONm8Q53VcaZdgRgIhA-TaM8',
    appId: '1:604948792312:web:41b3455596194a72508c0d',
    messagingSenderId: '604948792312',
    projectId: 'devmark-sample-login',
    authDomain: 'devmark-sample-login.firebaseapp.com',
    storageBucket: 'devmark-sample-login.firebasestorage.app',
    measurementId: 'G-RS3DZWV1RK',
  );

}