import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profilePic;
  final likes;

  const Post({
    required this.username,
    required this.uid,
    required this.description,
    required this.datePublished,
    required this.profilePic,
    required this.likes,
    required this.postId,
    required this.postUrl,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot["username"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      postId: snapshot["postId"],
      postUrl: snapshot["postUrl"],
      likes: snapshot["likes"],
      profilePic: snapshot["profilePic"],
      datePublished: snapshot["DatePublished"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postId": postId,
        "postUrl": postUrl,
        "likes": likes,
        "profilePic": profilePic,
        "datePublished": datePublished,
      };
}
