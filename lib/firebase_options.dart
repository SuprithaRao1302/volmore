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
    apiKey: 'AIzaSyCK4zSLAKZlCXDFXzjmn16NEGrTBCDbPmU',
    appId: '1:511187741190:web:3e87506fd6794182e0f187',
    messagingSenderId: '511187741190',
    projectId: 'volmore-d3502',
    authDomain: 'volmore-d3502.firebaseapp.com',
    storageBucket: 'volmore-d3502.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjTa5ZtwNM5Oq-pV8SlaznsqWMpw_O-5o',
    appId: '1:511187741190:android:5034b97192ddf860e0f187',
    messagingSenderId: '511187741190',
    projectId: 'volmore-d3502',
    storageBucket: 'volmore-d3502.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9TCkl0m9XLrNgP7bK1MYRH9TqZ23rDq4',
    appId: '1:511187741190:ios:31dfd73caa187ca6e0f187',
    messagingSenderId: '511187741190',
    projectId: 'volmore-d3502',
    storageBucket: 'volmore-d3502.appspot.com',
    iosBundleId: 'com.example.volmore',
  );
}
