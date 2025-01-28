import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instaflurt3/firebase_options.dart';
import 'package:instaflurt3/screens/login_screen.dart';
import 'package:instaflurt3/screens/signupscreen.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
    await FirebaseAppCheck.instance.activate(
        webProvider:
            ReCaptchaV3Provider('1f872f53-348a-4fcb-9baa-3352e323d0f5')); //debug site key
  } else {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
    await FirebaseAppCheck.instance
        .activate(androidProvider: AndroidProvider.debug); //debug
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InstaFlurt',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      home: LoginScreen(),
    );
  }
}
