import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaflurt3/firebase_resources/storage_method.dart';
import 'package:instaflurt3/models/Reels.dart';
import 'package:uuid/uuid.dart';

class FirestoreReel {
  final FirebaseFirestore _firestoreReels = FirebaseFirestore.instance;

  Future<String> UploadReel(
    String description,
    String uid,
    String username,
    String profilePic,
    XFile reelVideo,
  ) async {
    String res = "Some Error Occured";
    try {
      String videoUrl = await StorageMethod()
          .uploadVideoToStorage('Reel_Video', reelVideo, true);

      String reelId = const Uuid().v1();
      Reels reel = Reels(
        description: description,
        profilePic: profilePic,
        uid: uid,
        username: username,
        likes: [],
        reelId: reelId,
        reelUrl: videoUrl,
        datePublished: DateTime.now(),
      );
      await _firestoreReels.collection('Reels').doc(reelId).set(
            reel.toJson(),
          );
      res = "success";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
    print(res.toString());
    return res;
  }
}
