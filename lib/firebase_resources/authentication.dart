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

  /// Fetches the current user's details from Firestore.
  ///
  /// This method retrieves the user's data from the 'users' collection in Firestore
  /// using the current user's UID.
  ///
  /// Throws an error if there is no current user authenticated.
  Future<model.User> getUserDetails() async {
    // Get the currently authenticated user.
    User currentUser = _auth.currentUser!;

    // Get the document snapshot from Firestore for the current user.
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(currentUser.uid).get();

    // Return the user details parsed from the snapshot.
    return model.User.fromSnap(snap);
  }

  /// Signs up a new user with email and password.
  ///
  /// This method creates a new user in Firebase Authentication and stores their
  /// information in Firestore.
  ///
  /// [email] The user's email address.
  /// [password] The user's password.
  /// [username] The user's chosen username.
  /// [bio] The user's bio.
  /// [image] The user's profile picture as a Uint8List.
  ///
  /// Returns a success message on successful signup, otherwise returns an error message.
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List image,
  }) async {
    try {
      // Check if all required fields are filled.
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          image.isNotEmpty &&
          bio.isNotEmpty) {
        // Create the user with email and password in Firebase Authentication.
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid); // Log the newly created user's UID.

        // Upload the profile image to Firebase Storage and get the download URL.
        String photoUrl = await StorageMethod()
            .uploadImageToStorage('profilepic', image, false);

        // Create a User object with the provided and generated data.
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

        // Store the user data in Firestore under the 'users' collection.
        await _firebaseFirestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        return 'Signup successful';
      } else {
        return 'Please fill all the fields';
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Authentication exceptions.
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.Minimum length is 6 characters';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email. Please login.';
      } else if (e.code == 'invalid-email') {
        return 'Email address is not valid or badly formatted.';
      } else {
        return e.toString(); // Return the raw error message for other cases.
      }
    } catch (err) {
      // Handle other generic errors.
      return err.toString();
    }
  }

  /// Logs in an existing user with email and password.
  ///
  /// [email] The user's email address.
  /// [password] The user's password.
  ///
  /// Returns a success message on successful login, otherwise returns an error message.
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured"; // Default error message.

    try {
      // Sign in the user with email and password using Firebase Authentication.
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //checks if the user exists,if not return null
      if (cred.user == null) {
        return "user is null";
      }
      res = 'Login successful'; // Update the result on successful login.
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Authentication exceptions.
      if (e.code == 'user-not-found') {
        res = "user not found";
      } else if (e.code == 'wrong-password') {
        res = "wrong password";
      } else if (e.code == 'invalid-credential') {
        res = "invalid credential";
      } else if (e.code == ' ') {
        res = "please provide email or password";
      } else {
        res = e.message
            .toString(); // Return the raw error message for other cases.
      }
    } catch (e) {
      // Handle other generic errors.
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

  /// Signs out the current user.
  ///
  /// This method signs out the user from Firebase Authentication.
  Future<void> signOut() async {
    await _auth.signOut();
    // await _googleSignIn.signOut();
  }
}

/////
// }
