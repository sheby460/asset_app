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
    apiKey: 'AIzaSyDzWRn-uDscM1lQj07kOcYYc0FfNm5_dEg',
    appId: '1:229649304854:web:46a615343d425ab44ad437',
    messagingSenderId: '229649304854',
    projectId: 'assets-e6a9d',
    authDomain: 'assets-e6a9d.firebaseapp.com',
    storageBucket: 'assets-e6a9d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBd41pHLau90xYzfxrSD2bZL5nqcP3pWSM',
    appId: '1:229649304854:android:e775247843322a7a4ad437',
    messagingSenderId: '229649304854',
    projectId: 'assets-e6a9d',
    storageBucket: 'assets-e6a9d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtvkzxBiUUH1r-OEcXi3MwxIg49ocWgSg',
    appId: '1:229649304854:ios:688f038e7e05ad654ad437',
    messagingSenderId: '229649304854',
    projectId: 'assets-e6a9d',
    storageBucket: 'assets-e6a9d.appspot.com',
    androidClientId: '229649304854-7dffe49rgmkjvh0s4i3c9a7qpnrurhgj.apps.googleusercontent.com',
    iosClientId: '229649304854-9pov9ag444koqj0cce335rlfooqi2om6.apps.googleusercontent.com',
    iosBundleId: 'com.example.assetApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtvkzxBiUUH1r-OEcXi3MwxIg49ocWgSg',
    appId: '1:229649304854:ios:688f038e7e05ad654ad437',
    messagingSenderId: '229649304854',
    projectId: 'assets-e6a9d',
    storageBucket: 'assets-e6a9d.appspot.com',
    androidClientId: '229649304854-7dffe49rgmkjvh0s4i3c9a7qpnrurhgj.apps.googleusercontent.com',
    iosClientId: '229649304854-9pov9ag444koqj0cce335rlfooqi2om6.apps.googleusercontent.com',
    iosBundleId: 'com.example.assetApp',
  );
}