import 'package:firebase_app_check/firebase_app_check.dart';

Future<String?> getAppCheckToken() async {
  try {
    return await FirebaseAppCheck.instance.getToken();
  } catch (e) {
    print('Error getting App Check token: $e');
    return null;
  }
}

// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:instaflurt3/firebase_resources/Appcheck.dart';
// import 'package:instaflurt3/firebase_resources/storage_method.dart';

// class Authentication {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   Future<String> signupUser({
//     required String email,
//     required String password,
//     required String username,
//     required String bio,
//     required Uint8List image,
//   }) async {
//     final token = await getAppCheckToken();
//     print(token);
//     String res = 'some error';
//     if (token != null) {
//       try {
//         if (email.isNotEmpty ||
//             password.isNotEmpty ||
//             username.isNotEmpty ||
//             bio.isNotEmpty ||
//             image.isNotEmpty) {
//           UserCredential cred = await _auth.createUserWithEmailAndPassword(
//               email: email, password: password);
//           print(cred.user!.uid);

//           String photoUrl = await StorageMethod()
//               .uploadImageToStorage('profilepic', image, false);

//           // firebase firestore
//           _firebaseFirestore.collection('user1').doc(cred.user!.uid).set({
//             'username': username,
//             'uid': cred.user!.uid,
//             'bio': bio,
//             'photoUrl': photoUrl,
//             'email': email,
//             'follower': [],
//             'following': []
//           });
//         }
//       } catch (err) {
//         res = err.toString();
//       }
//     }
//     return res;
//   }
// }
