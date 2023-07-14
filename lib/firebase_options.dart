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
    apiKey: 'AIzaSyDnxSOnRGxFppLMCBME-Ep6tRQCaaFUgDg',
    appId: '1:1009990067213:web:ba4692f055b4bb7b416144',
    messagingSenderId: '1009990067213',
    projectId: 'my-ege-turbo',
    authDomain: 'my-ege-turbo.firebaseapp.com',
    storageBucket: 'my-ege-turbo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZ0jYsBnh07y3LItYTQYh6Ea2GHOaCVQU',
    appId: '1:1009990067213:android:5d193c849daf952a416144',
    messagingSenderId: '1009990067213',
    projectId: 'my-ege-turbo',
    storageBucket: 'my-ege-turbo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDHOcq6q7XsufoJMApYK-r553YDG6mcP58',
    appId: '1:1009990067213:ios:018aea6f525c9bbb416144',
    messagingSenderId: '1009990067213',
    projectId: 'my-ege-turbo',
    storageBucket: 'my-ege-turbo.appspot.com',
    iosClientId: '1009990067213-2e80mhg57vj6cift3iugn4kk4kd9ifht.apps.googleusercontent.com',
    iosBundleId: 'com.example.turboapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDHOcq6q7XsufoJMApYK-r553YDG6mcP58',
    appId: '1:1009990067213:ios:a07b8c24244b50bc416144',
    messagingSenderId: '1009990067213',
    projectId: 'my-ege-turbo',
    storageBucket: 'my-ege-turbo.appspot.com',
    iosClientId: '1009990067213-o2r06bqt03o063huqm60m868q4plb0ve.apps.googleusercontent.com',
    iosBundleId: 'com.example.turboapp.RunnerTests',
  );
}
