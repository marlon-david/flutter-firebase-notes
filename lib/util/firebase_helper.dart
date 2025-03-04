import 'package:private_notes/util/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class FirebaseHelper {
  static Future<bool> initializeFlutterFire() async {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      return Future.value(true);
  }
}