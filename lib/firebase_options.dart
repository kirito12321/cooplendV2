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
    apiKey: 'AIzaSyD4W_XomWm-K_0sZ4ix734RtTQNdQhQB0s',
    appId: '1:68596854899:web:8e03152a0fe1b152fbba06',
    messagingSenderId: '68596854899',
    projectId: 'my-ascoop-project',
    authDomain: 'my-ascoop-project.firebaseapp.com',
    storageBucket: 'my-ascoop-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkOAyP49w4Wck8P2JjZeEFb37wzS2XvfM',
    appId: '1:68596854899:android:2a2450b33d5f8f4ffbba06',
    messagingSenderId: '68596854899',
    projectId: 'my-ascoop-project',
    storageBucket: 'my-ascoop-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-KHe12QZVwMJEMyZlzQdeGVW9HwBRpbI',
    appId: '1:68596854899:ios:b8b54442ea178292fbba06',
    messagingSenderId: '68596854899',
    projectId: 'my-ascoop-project',
    storageBucket: 'my-ascoop-project.appspot.com',
    iosClientId:
        '68596854899-3m8thg86qd525kvl9pk9piaccgv2kequ.apps.googleusercontent.com',
    iosBundleId: 'com.example.ascoop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-KHe12QZVwMJEMyZlzQdeGVW9HwBRpbI',
    appId: '1:68596854899:ios:b8b54442ea178292fbba06',
    messagingSenderId: '68596854899',
    projectId: 'my-ascoop-project',
    storageBucket: 'my-ascoop-project.appspot.com',
    iosClientId:
        '68596854899-3m8thg86qd525kvl9pk9piaccgv2kequ.apps.googleusercontent.com',
    iosBundleId: 'com.example.ascoop',
  );
}