// Generated from Firebase Console / google-services.json for project esim-krd.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured for eSIM KRD.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'Firebase is not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-bX0pji2C73XtuT-C_xQUGfgq1Q77Ghc',
    appId: '1:302196387275:android:fc8ac790572085d909da4e',
    messagingSenderId: '302196387275',
    projectId: 'esim-krd',
    storageBucket: 'esim-krd.firebasestorage.app',
  );

  /// Values from `ios/Runner/GoogleService-Info.plist` (Firebase Console iOS app).
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8FGfplefZSlXHrftmuMzidRRaTs6i57M',
    appId: '1:302196387275:ios:747ca74668172f0109da4e',
    messagingSenderId: '302196387275',
    projectId: 'esim-krd',
    storageBucket: 'esim-krd.firebasestorage.app',
    iosBundleId: 'com.karoxghafoor.esimkrd',
  );
}
