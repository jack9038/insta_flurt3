import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

//adding image to firebase storage

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childname, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childname).child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadurl = await snap.ref.getDownloadURL();

    return downloadurl;
  }
}

// import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class StorageMethod {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<String> uploadImageToStorage(
//       String childname, Uint8List file, bool isPost) async {
//     try {
//       // 1. Generate a unique file name (optional)
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
//           (isPost ? '_post' : '_profile');

//       // 2. Create a reference to the storage location
//       Reference ref = _storage
//           .ref()
//           .child(childname)
//           .child(_auth.currentUser!.uid)
//           .child(fileName);

//       // 3. Upload the file with metadata (optional)
//       UploadTask uploadTask = ref.putData(file, metadata: {
//         'contentType': 'image/jpeg', // Example: Set content type
//         'isPost': isPost, // Example: Add custom metadata
//       });

//       // 4. Track upload progress (optional)
//       uploadTask.snapshotEvents.listen((event) {
//         if (event.state == TaskState.running) {
//           // Update UI with progress (e.g., progress bar)
//         } else if (event.state == TaskState.success) {
//           // Upload complete
//         } else if (event.state == TaskState.error) {
//           // Handle upload error
//         }
//       }, onError: (error) {
//         // Handle upload error
//       });

//       // 5. Wait for the upload to complete
//       TaskSnapshot snap = await uploadTask;

//       // 6. Get the download URL
//       String downloadUrl = await snap.ref.getDownloadURL();

//       return downloadUrl;
//     } catch (e) {
//       // Handle errors gracefully
//       print('Error uploading image: $e');
//       throw Exception('Failed to upload image');
//     }
//   }
// }
