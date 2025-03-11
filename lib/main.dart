import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instaflurt3/firebase_options.dart';
import 'package:instaflurt3/provider/user_provider.dart';
import 'package:instaflurt3/responsive/mobilescreen.dart';
import 'package:instaflurt3/responsive/responsive_layout.dart';
import 'package:instaflurt3/responsive/webscreen.dart';
import 'package:instaflurt3/screens/login_screen.dart';
import 'package:instaflurt3/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  } else {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final _noScreenshot = NoScreenshot.instance;

  @override
  // void initState() {
  //   super.initState();
  //   _startScreenshotListening();
  //   _listenForScreenshot();
  //   _disableScreenshot();
  // }

  // void _startScreenshotListening() async {
  //   await _noScreenshot.startScreenshotListening();
  // }

  // void _listenForScreenshot() {
  //   _noScreenshot.screenshotStream.listen((event) {
  //     if (event.wasScreenshotTaken) {
  //       _showCustomAlert();
  //     }
  //   });
  // }

  // void _showCustomAlert() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         child: Container(
  //           padding: const EdgeInsets.all(20.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Icon(
  //                 Icons.warning_amber_outlined,
  //                 size: 80,
  //                 color: Colors.red,
  //               ),
  //               const Text(
  //                 "Screenshot detected",
  //                 style: TextStyle(fontSize: 24),
  //               ),
  //               const SizedBox(height: 20),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text("Dismiss"),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _disableScreenshot() async {
  //   bool result = await _noScreenshot.screenshotOff();
  //   debugPrint('Screenshot Disabled: $result');
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InstaFlurt',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobile: MobileScreenLayout(),
                  web: Webscreen(),
                );
              } else if (snapshot.hasError) {
                if (snapshot.error is FirebaseException) {
                  FirebaseException firebaseException =
                      snapshot.error as FirebaseException;
                  return Center(
                    child: Text(
                        'Error: ${firebaseException.code.toString()} - ${firebaseException.message.toString()}'),
                  );
                } else {
                  return Center(
                    child: Text(
                        'An unexpected error occurred: ${snapshot.error.toString()}'),
                  );
                }
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}










// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:instaflurt3/firebase_options.dart';
// import 'package:instaflurt3/provider/user_provider.dart';
// import 'package:instaflurt3/responsive/mobilescreen.dart';
// import 'package:instaflurt3/responsive/responsive_layout.dart';
// import 'package:instaflurt3/responsive/webscreen.dart';
// import 'package:instaflurt3/screens/login_screen.dart';
// // import 'package:instaflurt3/screens/signupscreen.dart';
// import 'package:instaflurt3/utils/colors.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
// import 'package:instaflurt3/widgets/noscreenshort.dart';
// import 'package:provider/provider.dart';
// // import 'package:instaflurt3/utils/dimensions.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (kIsWeb) {
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
//     await FirebaseAppCheck.instance.activate(
//       webProvider:
//           ReCaptchaV3Provider('6LfvMMgqAAAAAMOQcnswL6o9K159_3FdywYkb7i8'),
//     );
//   } else {
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
//     await FirebaseAppCheck.instance
//         .activate(androidProvider: AndroidProvider.playIntegrity);
//   }
//   runApp(const MyApp());
  
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => UserProvider(),
//         ),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'InstaFlurt',
//         theme: ThemeData.dark()
//             .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
//         home: StreamBuilder(
//             stream: FirebaseAuth.instance.authStateChanges(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.active) {
//                 if (snapshot.hasData) {
//                   return const ResponsiveLayout(
//                       mobile: Mobilescreen(), web: Webscreen());
//                 } else if (snapshot.hasError) {
//                   if (snapshot.error is FirebaseException) {
//                     FirebaseException firebaseException =
//                         snapshot.error as FirebaseException;
//                     return Center(
//                       child: Text(
//                           'Error: ${firebaseException.code.toString()} - ${firebaseException.message.toString()}'),
//                     );
//                   } else {
//                     return Center(
//                       child: Text(
//                           'An unexpected error occurred: ${snapshot.error.toString()}'),
//                     );
//                   }
//                 }
//               }
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     color: primaryColor,
//                   ),
//                 );
//               }
//               return LoginScreen();
//             }),
//       ),
//     );
//   }
// }
