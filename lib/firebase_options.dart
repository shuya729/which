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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB1_PFn6UddnjDvUQapPXMdAgc6ANo5Ch0',
    appId: '1:1098469953657:web:291e429edc0d3f03b9c4a8',
    messagingSenderId: '1098469953657',
    projectId: 'which-464',
    authDomain: 'which-464.firebaseapp.com',
    storageBucket: 'which-464.appspot.com',
    measurementId: 'G-0K5X5HVZ9X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARdwN0VCAt-HpYh-CgwwI-TCCKY2TXlKs',
    appId: '1:1098469953657:android:7af68201092d00adb9c4a8',
    messagingSenderId: '1098469953657',
    projectId: 'which-464',
    storageBucket: 'which-464.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8fMVcChGMz9ETEgqeP-a4osnW0GSiLD4',
    appId: '1:1098469953657:ios:5e7569601be32366b9c4a8',
    messagingSenderId: '1098469953657',
    projectId: 'which-464',
    storageBucket: 'which-464.appspot.com',
    androidClientId: '1098469953657-82sbs76lvgl46cmsdhaam672cbneptcr.apps.googleusercontent.com',
    iosClientId: '1098469953657-296ue5ap8blmkmjhedhcmlm7h84b3egv.apps.googleusercontent.com',
    iosBundleId: 'com.which464.which',
  );

}