import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import 'package:instaflurt3/firebase_resources/storage_method.dart';
import 'package:instaflurt3/models/users.dart' as model;

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List image,
  }) async {
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          image.isNotEmpty &&
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoUrl = await StorageMethod()
            .uploadImageToStorage('profilepic', image, false);

        // firebase firestore
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
          username: username,
          createdAt: Timestamp.now(),
        );

        await _firebaseFirestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        return 'Signup successful';
      } else {
        return 'Please fill all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.Minimum length is 6 characters';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email. Please login.';
      } else if (e.code == 'invalid-email') {
        return 'Email address is not valid or badly formatted.';
      } else {
        return e.toString();
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";

    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user == null) {
        return "user is null";
      }
      res = 'Login successful';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "user not found";
      } else if (e.code == 'wrong-password') {
        res = "wrong password";
      } else if (e.code == 'invalid-credential') {
        res = "invalid credential";
      } else if (e.code == ' ') {
        res = "please provide email or password";
      } else {
        res = e.message.toString();
      }
    } catch (e) {
      res = e.toString();
    }
    return res.toString();
  }

//google signin

//   Future<String> signInWithGoogle() async {
//     final token = await getAppCheckToken();
//     String res = 'Some error occured';
//     if (token != null) {
//       try {
//         final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//         if (googleUser == null) {
//           return 'Sign-In aborted by user';
//         }

//         final GoogleSignInAuthentication googleAuth =
//             await googleUser.authentication;

//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );

//         UserCredential userCredential =
//             await _auth.signInWithCredential(credential);

//         print('User UID: ${userCredential.user!.uid}'); // Debugging
//         print(userCredential.user!.displayName); // Debugging

//         // Check if the user is new

//         await _firebaseFirestore
//             .collection('user1')
//             .doc(userCredential.user!.uid)
//             .set({
//           'username': googleUser.displayName ?? '',
//           'uid': userCredential.user!.uid,
//           'email': googleUser.email,
//           'bio': '',
//           'photoUrl': googleUser.photoUrl ?? '',
//           'follower': [],
//           'following': [],
//           'createdAt': FieldValue.serverTimestamp(),
//         });

//         return 'Sign-In successful';
//       } catch (e) {
//         print('Google Sign-In Error: $e');
//         return 'Error signing in with Google: ${e.toString()}';
//       }
//     } else {
//       return res.toString();
//     }
//   }

  Future<void> signOut() async {
    await _auth.signOut();
    // await _googleSignIn.signOut();
  }
}

/////
// }
