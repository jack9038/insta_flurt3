import 'package:cloud_firestore/cloud_firestore.dart';

class Reels {
  final String description;
  final String uid;
  final String username;
  final String reelId;
  final datePublished;
  final String reelUrl;
  final String profilePic;
  final likes;


  const Reels({
    required this.username,
    required this.uid,
    required this.description,
    required this.datePublished,
    required this.profilePic,
    required this.likes,
    required this.reelId,
    required this.reelUrl,
  
  });

  static Reels fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Reels(
      username: snapshot["username"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      reelId: snapshot["reelId"],
      reelUrl: snapshot["reelUrl"],
      likes: snapshot["likes"],
      profilePic: snapshot["profilePic"],
      datePublished: snapshot["DatePublished"],
    
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "reelId": reelId,
        "reelUrl": reelUrl,
        "likes": likes,
        "profilePic": profilePic,
        "datePublished": datePublished,
  
      };
}
