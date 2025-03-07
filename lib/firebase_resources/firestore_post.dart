import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:instaflurt3/firebase_resources/storage_method.dart';
import 'package:instaflurt3/models/post.dart';
import 'package:uuid/uuid.dart';

class FirestorePost {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profilePic,
  ) async {
    String res = "Some Error Occured";

    try {
      String photoUrl =
          await StorageMethod().uploadImageToStorage('Post Image', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        profilePic: profilePic,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        
      );
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> LikePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> PostComment(String postId, String text, String uid, String name,
      String profilePic) async {
    String commentId = const Uuid().v1();
    try {
      if (text.isNotEmpty) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'profilePic': profilePic,
            'name': name,
            'uid': uid,
            'text': text,
            'commentId': commentId,
            'datePublished': DateTime.now(),
          },
        );
      } else {
        print("text is empty . An empty comment");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> DeletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
