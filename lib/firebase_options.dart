// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyAsJX-z5z93fXyzsBt2ZZ0A2PJrpWu726s',
    appId: '1:507115540774:web:87459e3a9ec3412367f1e7',
    messagingSenderId: '507115540774',
    projectId: 'app-stories-7e663',
    authDomain: 'app-stories-7e663.firebaseapp.com',
    storageBucket: 'app-stories-7e663.appspot.com',
    measurementId: 'G-Z7KYPNJLVX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjkNznq8DoDKDk6q1l5Ebn6oX3xx43rJ4',
    appId: '1:507115540774:android:8d107a0f6d290dc867f1e7',
    messagingSenderId: '507115540774',
    projectId: 'app-stories-7e663',
    storageBucket: 'app-stories-7e663.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxLtYtJOD9ZoxnIH90y4-J6C0HW5Sqe98',
    appId: '1:507115540774:ios:7d0cd195b16e27d067f1e7',
    messagingSenderId: '507115540774',
    projectId: 'app-stories-7e663',
    storageBucket: 'app-stories-7e663.appspot.com',
    iosBundleId: 'com.example.appStories',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDxLtYtJOD9ZoxnIH90y4-J6C0HW5Sqe98',
    appId: '1:507115540774:ios:7d0cd195b16e27d067f1e7',
    messagingSenderId: '507115540774',
    projectId: 'app-stories-7e663',
    storageBucket: 'app-stories-7e663.appspot.com',
    iosBundleId: 'com.example.appStories',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAsJX-z5z93fXyzsBt2ZZ0A2PJrpWu726s',
    appId: '1:507115540774:web:fc98fb0086bd892767f1e7',
    messagingSenderId: '507115540774',
    projectId: 'app-stories-7e663',
    authDomain: 'app-stories-7e663.firebaseapp.com',
    storageBucket: 'app-stories-7e663.appspot.com',
    measurementId: 'G-JYW0NV1JVJ',
  );
}
