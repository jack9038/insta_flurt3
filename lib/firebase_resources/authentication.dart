import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instaflurt3/firebase_resources/Appcheck.dart';
import 'package:instaflurt3/firebase_resources/storage_method.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List image,
  }) async {
    final token = await getAppCheckToken();
    if (token != null) {
      try {
        if (email.isNotEmpty &&
            password.isNotEmpty &&
            username.isNotEmpty &&
            bio.isNotEmpty &&
            image.isNotEmpty) {
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          print(cred.user!.uid);

          String photoUrl = await StorageMethod()
              .uploadImageToStorage('profilepic', image, false);

          // firebase firestore
          await _firebaseFirestore.collection('user1').doc(cred.user!.uid).set({
            'username': username,
            'uid': cred.user!.uid,
            'bio': bio,
            'photoUrl': photoUrl,
            'email': email,
            'follower': [],
            'following': [],
            'createdAt': FieldValue.serverTimestamp(), // Add timestamp
          });

          return 'Signup successful';
        } else {
          return 'Please fill all the fields';
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        } else {
          return e.code.toString();
        }
      } catch (err) {
        return err.toString();
      }
    } else {
      return 'Please enable App Check';
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';
    final token = await getAppCheckToken();
    if (token != null) {
      try {
        if (email.isNotEmpty || password.isNotEmpty) {
          await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          res = 'Login successful';
        } else {
          res = 'Please fill all the fields';
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'provide';
        }
      } catch (e) {
        res = e.toString();
      }
      return res;
    } else {
      return res.toString();
    }
  }

//google signin

  Future<String> signInWithGoogle() async {
    final token = await getAppCheckToken();
    String res = 'Some error occured';
    if (token != null) {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return 'Sign-In aborted by user';
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Check if the user is new

        await _firebaseFirestore
            .collection('user1')
            .doc(userCredential.user!.uid)
            .set({
          'username': googleUser.displayName ?? '',
          'uid': userCredential.user!.uid,
          'email': googleUser.email,
          'bio': '',
          'photoUrl': googleUser.photoUrl ?? '',
          'follower': [],
          'following': [],
          'createdAt': FieldValue.serverTimestamp(),
        });

        return 'Sign-In successful';
      } catch (e) {
        print('Google Sign-In Error: $e');
        return 'Error signing in with Google: ${e.toString()}';
      }
    } else {
      return res.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
